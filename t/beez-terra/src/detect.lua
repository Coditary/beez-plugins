local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

local function is_test_path(path)
    return path:match("/tests/") ~= nil
        or path:match("/test/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("^test/") ~= nil
end

function M.entry_name(source_path, fallback)
    if source_path == nil then
        return fallback or "app"
    end

    local name = basename(source_path):match("^(.+)%.t$")
    if name ~= nil then
        return name
    end

    name = basename(source_path):match("^(.+)%.lua$")
    return name or fallback or "app"
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local package_name = output_name or "app"
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "main.t",
        prefix .. "src/main.t",
        prefix .. package_name .. ".t",
        prefix .. "src/" .. package_name .. ".t",
        prefix .. "main.lua",
        prefix .. "src/main.lua",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    stamp = nil,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local t_files = ctx.glob({ prefix .. "*.t", prefix .. "src/*.t" })
        sort_shallow_first(t_files)
        for _, source in ipairs(t_files) do
            if not is_test_path(source) then
                targets[#targets + 1] = {
                    source = source,
                    name = M.entry_name(source, package_name),
                    stamp = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("terra plugin: no .t or .lua entry point found — add main.t or configure targets")
    end

    return targets
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "tests/**/*.t",
        prefix .. "test/**/*.t",
        prefix .. "tests/**/*.lua",
        prefix .. "test/**/*.lua",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local t_files = ctx.glob({ "**/*.t" })
    local lua_files = ctx.glob({ "**/*.lua" })

    if #t_files == 0 and #lua_files == 0 then
        error("terra plugin: no *.t or *.lua files found — add Terra sources or set targets in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/terra"
    for _, target in ipairs(targets) do
        if target.stamp == nil then
            target.stamp = bin_dir .. "/" .. (target.name or output_name) .. ".ok"
        end
    end

    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].stamp,
        primary_source = targets[1].source,
        has_tests = has_tests,
    }
end

return M
