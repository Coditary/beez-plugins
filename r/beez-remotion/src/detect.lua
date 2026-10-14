local M = {}

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

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function read_file(path, max_bytes)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return ""
    end

    local content = file:read(max_bytes or 8192)
    file:close()
    return content or ""
end

function M.has_remotion_dependency(package_json_path)
    if package_json_path == nil then
        return false
    end

    local content = read_file(package_json_path)
    return content:match('"@?remotion[^"]*"') ~= nil
        or content:match('"remotion"') ~= nil
end

function M.find_package_json(ctx)
    local files = ctx.glob({ "package.json", "**/package.json" })
    sort_shallow_first(files)

    for _, file in ipairs(files) do
        if M.has_remotion_dependency(file) then
            return file
        end
    end

    if #files > 0 then
        return files[1]
    end

    return nil
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = glob_prefix(root)
    local candidates = {
        prefix .. "src/index.tsx",
        prefix .. "src/index.ts",
        prefix .. "src/Root.tsx",
        prefix .. "src/Video.tsx",
        prefix .. "remotion/index.tsx",
        prefix .. "index.tsx",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            return matches[1]
        end
    end

    local tsx_files = ctx.glob({ prefix .. "src/**/*.tsx", prefix .. "src/**/*.ts" })
    sort_shallow_first(tsx_files)
    for _, file in ipairs(tsx_files) do
        if not file:match("/test/") and not file:match("/tests/") and not file:match("%.d%.ts$") then
            return file
        end
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = glob_prefix(root)
    local test_files = ctx.glob({
        prefix .. "src/**/*.test.ts",
        prefix .. "src/**/*.test.tsx",
        prefix .. "src/**/*.spec.ts",
        prefix .. "src/**/*.spec.tsx",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local ts_files = ctx.glob({ "**/*.ts", "**/*.tsx" })
    if package_json_path == nil and #ts_files == 0 then
        error("remotion plugin: no package.json with remotion or *.ts/*.tsx found — add a Remotion project or set project_root in configure()")
    end

    if package_json_path ~= nil and not M.has_remotion_dependency(package_json_path) then
        error("remotion plugin: package.json found but no remotion dependency — add remotion to package.json")
    end

    local root = cfg.project_root or "."
    if package_json_path ~= nil and (root == "." or root == "") then
        root = dirname(package_json_path)
    end

    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    if entry_source == nil then
        error("remotion plugin: no Remotion entry *.tsx/*.ts found — add src/index.tsx or set entry_source in configure()")
    end

    local composition_id = cfg.composition_id or "Main"
    local bin_dir = cfg.bin_dir or "build/remotion/bin"
    local output_name = cfg.output_name or "app.mp4"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        package_json_path = package_json_path,
        entry_source = entry_source,
        composition_id = composition_id,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
