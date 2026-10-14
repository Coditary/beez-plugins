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

function M.find_package_json(ctx)
    local files = ctx.glob({ "package.json", "**/package.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(package_json_path)
    if package_json_path ~= nil then
        return dirname(package_json_path)
    end
    return "."
end

local function read_package_json(path)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return nil
    end

    local content = file:read("*a")
    file:close()
    return content
end

function M.package_name(package_json_path)
    if package_json_path == nil then
        return "app"
    end

    local content = read_package_json(package_json_path)
    if content ~= nil then
        local name = content:match('"name"%s*:%s*"([^"]+)"')
        if name ~= nil and name ~= "" then
            return name:gsub("/", "-")
        end
    end

    return basename(dirname(package_json_path))
end

function M.entry_from_package_json(package_json_path, root)
    if package_json_path == nil then
        return nil
    end

    local content = read_package_json(package_json_path)
    if content == nil then
        return nil
    end

    local prefix = root
    if prefix ~= "." and prefix ~= "" then
        prefix = prefix .. "/"
    else
        prefix = ""
    end

    for _, field in ipairs({ "module", "main", "browser" }) do
        local entry = content:match('"' .. field .. '"%s*:%s*"([^"]+)"')
        if entry ~= nil and entry ~= "" and not entry:match("^https?://") then
            entry = entry:gsub("^%.%/", "")
            return prefix .. entry
        end
    end

    return nil
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root, package_json_path, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local package_entry = M.entry_from_package_json(package_json_path, root)
    if package_entry ~= nil then
        local matches = ctx.glob({ package_entry })
        if #matches > 0 then
            targets[#targets + 1] = {
                source = matches[1],
                name = output_name,
                output = nil,
            }
            return targets
        end
    end

    local candidates = {
        prefix .. "src/index.ts",
        prefix .. "src/index.tsx",
        prefix .. "src/main.ts",
        prefix .. "src/main.tsx",
        prefix .. "src/index.js",
        prefix .. "src/main.js",
        prefix .. "index.ts",
        prefix .. "index.tsx",
        prefix .. "main.ts",
        prefix .. "main.tsx",
        prefix .. "index.js",
        prefix .. "main.js",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                targets[#targets + 1] = {
                    source = source,
                    name = output_name,
                    output = nil,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({
            prefix .. "src/*.ts",
            prefix .. "src/*.tsx",
            prefix .. "src/*.js",
        })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/tests/") and not source:match("/test/") and not source:match("%.d%.ts$") then
                local name = basename(source):match("^(.+)%.[^%.]+$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local root_files = ctx.glob({ prefix .. "*.ts", prefix .. "*.tsx", prefix .. "*.js" })
        sort_shallow_first(root_files)
        for _, source in ipairs(root_files) do
            if not source:match("%.d%.ts$") and not source:match("%.config%.") then
                local name = basename(source):match("^(.+)%.[^%.]+$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("esbuild plugin: no entry point found — add src/index.ts, index.js, or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_package_json(ctx)
    end

    local ts_files = ctx.glob({ "**/*.ts", "**/*.tsx" })
    local js_files = ctx.glob({ "**/*.js" })
    if package_json_path == nil and #ts_files == 0 and #js_files == 0 then
        error("esbuild plugin: no package.json or *.ts/*.tsx/*.js files found — add a JS/TS project or set package_json_path in configure()")
    end

    local root = cfg.project_root or M.project_root(package_json_path)
    local output_name = cfg.output_name or M.package_name(package_json_path)
    local dist_dir = cfg.dist_dir or "build/esbuild"
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, package_json_path, output_name)
    end

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = dist_dir .. "/" .. (target.name or output_name) .. ".js"
        end
    end

    return {
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        dist_dir = dist_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
