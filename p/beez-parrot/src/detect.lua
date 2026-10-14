local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
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
    return path:match("/t/") ~= nil
        or path:match("^t/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local patterns = {
        prefix .. "**/*.pir",
        prefix .. "**/*.pasm",
    }

    for _, pattern in ipairs(patterns) do
        local matches = ctx.glob({ pattern })
        sort_shallow_first(matches)
        for _, source in ipairs(matches) do
            if not seen[source] and not is_test_path(source) then
                seen[source] = true
                local name = basename(source):match("^(.+)%.[^%.]+$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
            end
        end
    end

    if #targets == 0 then
        local pbc_files = ctx.glob({ prefix .. "**/*.pbc" })
        sort_shallow_first(pbc_files)
        for _, source in ipairs(pbc_files) do
            if not is_test_path(source) then
                local name = basename(source):match("^(.+)%.pbc$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = source,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("parrot plugin: no .pir, .pasm, or .pbc files found — add Parrot sources or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local pir_files = ctx.glob({ "**/*.pir" })
    local pasm_files = ctx.glob({ "**/*.pasm" })
    local pbc_files = ctx.glob({ "**/*.pbc" })

    if #pir_files == 0 and #pasm_files == 0 and #pbc_files == 0 then
        error("parrot plugin: no *.pir, *.pasm, or *.pbc files found — add a Parrot project or set project_root in configure()")
    end

    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, output_name)
    end

    local bin_dir = cfg.bin_dir or "build/parrot"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name .. ".pbc"
        end
    end

    local test_dir = nil
    local test_dirs = ctx.glob({ "t", "t/**", root .. "/t", root .. "/t/**" })
    if #test_dirs > 0 then
        test_dir = "t"
        if root ~= "." and root ~= "" then
            test_dir = root .. "/t"
        end
    end

    return {
        project_root = root,
        package_name = output_name,
        targets = targets,
        bin_dir = bin_dir,
        has_test_dir = test_dir ~= nil,
        test_dir = test_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
