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

local function read_file(path)
    local ok, file = pcall(io.open, path, "r")
    if not ok or file == nil then
        return nil
    end

    local content = file:read("*a")
    file:close()
    return content
end

local function has_style_dictionary_reference(content)
    if content == nil then
        return false
    end

    return content:match("style%-dictionary") ~= nil
        or content:match('"styleDictionary"') ~= nil
        or content:match("'styleDictionary'") ~= nil
end

function M.find_manifest(ctx, pattern)
    local files = ctx.glob({ pattern, "**/" .. pattern })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_style_dictionary_config(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local explicit_configs = ctx.glob({
        prefix .. "/style-dictionary.config.js",
        prefix .. "/style-dictionary.config.json",
        prefix .. "/**/style-dictionary.config.js",
        prefix .. "/**/style-dictionary.config.json",
    })
    sort_shallow_first(explicit_configs)
    if #explicit_configs > 0 then
        return explicit_configs[1]
    end

    local config_files = ctx.glob({
        prefix .. "/config.json",
        prefix .. "/**/config.json",
    })
    sort_shallow_first(config_files)
    for _, config_path in ipairs(config_files) do
        if has_style_dictionary_reference(read_file(config_path)) then
            return config_path
        end
    end

    return nil
end

function M.resolve(ctx, cfg)
    local package_json_path = cfg.package_json_path
    if package_json_path == nil then
        package_json_path = M.find_manifest(ctx, "package.json")
    end

    local token_files = ctx.glob({ "**/tokens/**/*.json" })
    local root = cfg.project_root
    if root == nil then
        if package_json_path ~= nil then
            root = dirname(package_json_path)
        else
            root = "."
        end
    end

    local config_path = cfg.config_path
    if config_path == nil then
        config_path = M.find_style_dictionary_config(ctx, root)
    end

    if config_path == nil and #token_files == 0 and package_json_path == nil then
        error("style-dictionary plugin: no style-dictionary config, tokens/**/*.json, or package.json found — add token config or set config_path in configure()")
    end

    local dist_dir = cfg.dist_dir or "build/style-dictionary"
    local output_name = cfg.output_name or "tokens"
    local primary_output = dist_dir .. "/" .. output_name

    return {
        package_json_path = package_json_path,
        has_package_json = package_json_path ~= nil,
        config_path = config_path,
        has_config = config_path ~= nil,
        token_files = token_files,
        has_tokens = #token_files > 0,
        project_root = root,
        dist_dir = dist_dir,
        output_name = output_name,
        primary_output = primary_output,
    }
end

return M
