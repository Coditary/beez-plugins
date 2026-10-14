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

function M.find_pubspec(ctx)
    local files = ctx.glob({ "pubspec.yaml", "**/pubspec.yaml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(pubspec_path)
    if pubspec_path == nil then
        return "."
    end
    return dirname(pubspec_path)
end

function M.package_name(pubspec_path, output_name)
    if output_name ~= nil then
        return output_name
    end
    if pubspec_path == nil then
        return "app"
    end
    return basename(M.project_root(pubspec_path))
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_build_targets(ctx, root, pubspec_path, output_name)
    local prefix = glob_prefix(root)
    local default_name = output_name or M.package_name(pubspec_path, nil)
    local targets = {}
    local seen = {}

    local bin_files = ctx.glob({ prefix .. "bin/*.dart", prefix .. "bin/**/*.dart" })
    sort_shallow_first(bin_files)

    for _, source in ipairs(bin_files) do
        if not seen[source] then
            seen[source] = true
            local name = basename(source):match("^(.+)%.dart$") or default_name
            targets[#targets + 1] = {
                source = source,
                name = name,
                output = nil,
            }
        end
    end

    if #targets == 0 then
        local candidates = {
            prefix .. "lib/main.dart",
            prefix .. "web/main.dart",
            prefix .. "main.dart",
        }

        for _, pattern in ipairs(candidates) do
            local matches = ctx.glob({ pattern })
            for _, source in ipairs(matches) do
                if not seen[source] then
                    seen[source] = true
                    targets[#targets + 1] = {
                        source = source,
                        name = default_name,
                        output = nil,
                    }
                    break
                end
            end
            if #targets > 0 then
                break
            end
        end
    end

    if #targets == 0 then
        local dart_files = ctx.glob({ prefix .. "**/*.dart" })
        sort_shallow_first(dart_files)
        for _, source in ipairs(dart_files) do
            if not source:match("/test/") and not source:match("/tests/") then
                local name = basename(source):match("^(.+)%.dart$") or default_name
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
        error("ddc plugin: no .dart entry point found — add bin/main.dart or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local pubspec_path = cfg.pubspec_path
    if pubspec_path == nil then
        pubspec_path = M.find_pubspec(ctx)
    end

    local dart_files = ctx.glob({ "**/*.dart" })
    if pubspec_path == nil and #dart_files == 0 then
        error("ddc plugin: no pubspec.yaml or *.dart files found — add a Dart project or set pubspec_path in configure()")
    end

    local root = cfg.project_root or M.project_root(pubspec_path)
    local output_name = cfg.output_name or M.package_name(pubspec_path, nil)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root, pubspec_path, output_name)
    end

    local js_dir = cfg.js_dir or "build/ddc"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = js_dir .. "/" .. (target.name or output_name) .. ".js"
        end
    end

    return {
        pubspec_path = pubspec_path,
        has_pubspec = pubspec_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        js_dir = js_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
