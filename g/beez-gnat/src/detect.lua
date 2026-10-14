local M = {}

local function basename(path)
    return path:match("([^/]+)$") or path
end

local function stem(path)
    local name = basename(path)
    return name:match("^(.+)%.[^%.]+$") or name
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

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function is_test_path(path)
    local lower = path:lower()
    return lower:match("/tests/") ~= nil
        or lower:match("/test/") ~= nil
        or lower:match("test") ~= nil
end

function M.find_gpr(ctx)
    local files = ctx.glob({ "*.gpr", "**/*.gpr" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    for _, path in ipairs(files) do
        if not is_test_path(path) then
            return path
        end
    end

    return files[1]
end

function M.find_test_gpr(ctx, root)
    local prefix = glob_prefix(root)
    local files = ctx.glob({
        prefix .. "tests/*.gpr",
        prefix .. "tests/**/*.gpr",
        prefix .. "test/*.gpr",
        prefix .. "test/**/*.gpr",
    })

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(gpr_path)
    if gpr_path == nil then
        return "."
    end
    return dirname(gpr_path)
end

function M.project_name(gpr_path, output_name)
    if gpr_path ~= nil then
        return stem(gpr_path)
    end
    return output_name or "app"
end

function M.resolve_build_targets(ctx, root, gpr_path, output_name)
    local prefix = glob_prefix(root)
    local name = output_name or M.project_name(gpr_path, output_name)
    local targets = {}

    if gpr_path ~= nil then
        targets[#targets + 1] = {
            kind = "gpr",
            gpr_path = gpr_path,
            name = name,
            output = nil,
        }
        return targets
    end

    local preferred = ctx.glob({
        prefix .. "main.adb",
        prefix .. "src/main.adb",
        prefix .. "src/" .. name .. ".adb",
        prefix .. name .. ".adb",
        prefix .. "cmd/*/main.adb",
    })

    for _, source_path in ipairs(preferred) do
        if not is_test_path(source_path) then
            local target_name = name
            if source_path:match("/cmd/") then
                target_name = basename(dirname(source_path))
            else
                target_name = stem(source_path)
            end

            targets[#targets + 1] = {
                kind = "adb",
                source = source_path,
                name = target_name,
                output = nil,
            }
            return targets
        end
    end

    local adb_files = ctx.glob({ prefix .. "**/*.adb" })
    sort_shallow_first(adb_files)
    for _, source_path in ipairs(adb_files) do
        if not is_test_path(source_path) then
            targets[#targets + 1] = {
                kind = "adb",
                source = source_path,
                name = stem(source_path),
                output = nil,
            }
            return targets
        end
    end

    error("gnat plugin: no .gpr or .adb entry point found — add a GNAT project or main.adb")
end

function M.resolve_test_targets(ctx, root, gpr_path)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local test_gpr = M.find_test_gpr(ctx, root)
    if test_gpr ~= nil then
        targets[#targets + 1] = {
            kind = "gpr",
            gpr_path = test_gpr,
            name = "test_" .. stem(test_gpr),
            output = nil,
        }
        return targets
    end

    local tests = ctx.glob({
        prefix .. "tests/**/*.adb",
        prefix .. "test/**/*.adb",
        prefix .. "**/*_test.adb",
        prefix .. "**/test_*.adb",
    })

    sort_shallow_first(tests)
    for _, source_path in ipairs(tests) do
        if not seen[source_path] then
            seen[source_path] = true
            targets[#targets + 1] = {
                kind = "adb",
                source = source_path,
                name = "test_" .. stem(source_path),
                output = nil,
            }
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local gpr_path = cfg.gpr_path
    if gpr_path == nil then
        gpr_path = M.find_gpr(ctx)
    end

    local adb_files = ctx.glob({ "**/*.adb" })
    local ads_files = ctx.glob({ "**/*.ads" })
    if gpr_path == nil and #adb_files == 0 and #ads_files == 0 then
        error("gnat plugin: no *.gpr, *.adb, or *.ads files found — add an Ada project or set gpr_path in configure()")
    end

    local root = cfg.project_root or M.project_root(gpr_path)
    local output_name = cfg.output_name or M.project_name(gpr_path, "app")
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, gpr_path, output_name)
    end

    local test_targets = cfg.test_targets
    if test_targets == nil then
        test_targets = M.resolve_test_targets(ctx, root, gpr_path)
    end

    local bin_dir = cfg.bin_dir or "build/gnat/bin"

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    for _, target in ipairs(test_targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name
        end
    end

    return {
        gpr_path = gpr_path,
        has_gpr = gpr_path ~= nil,
        project_root = root,
        project_name = output_name,
        targets = targets,
        test_targets = test_targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        primary_gpr = targets[1].gpr_path,
    }
end

return M
