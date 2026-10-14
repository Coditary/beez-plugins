local M = {}

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

function M.find_babel_config(ctx)
    local patterns = {
        "babel.config.js",
        "babel.config.json",
        "babel.config.cjs",
        "babel.config.mjs",
        ".babelrc",
        ".babelrc.json",
        ".babelrc.js",
        "**/babel.config.js",
        "**/babel.config.json",
        "**/babel.config.cjs",
        "**/babel.config.mjs",
        "**/.babelrc",
        "**/.babelrc.json",
    }

    local files = ctx.glob(patterns)
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_package_json(ctx)
    local files = ctx.glob({ "package.json", "**/package.json" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_typescript_files(ctx, root)
    local prefix = glob_prefix(root)
    return ctx.glob({
        prefix .. "**/*.ts",
        prefix .. "**/*.tsx",
    })
end

function M.resolve_source_dirs(ctx, root, source_dirs)
    if source_dirs ~= nil then
        return source_dirs
    end

    local prefix = glob_prefix(root)
    local candidates = { "src", "lib", "app" }
    local resolved = {}

    for _, candidate in ipairs(candidates) do
        local matches = ctx.glob({
            prefix .. candidate .. "/**/*.ts",
            prefix .. candidate .. "/**/*.tsx",
        })
        if #matches > 0 then
            if root ~= "." and root ~= "" then
                resolved[#resolved + 1] = root .. "/" .. candidate
            else
                resolved[#resolved + 1] = candidate
            end
        end
    end

    if #resolved > 0 then
        return resolved
    end

    local root_files = ctx.glob({
        prefix .. "*.ts",
        prefix .. "*.tsx",
    })
    if #root_files > 0 then
        if root ~= "." and root ~= "" then
            return { root }
        end
        return { "." }
    end

    local all_ts = M.find_typescript_files(ctx, root)
    if #all_ts > 0 then
        if root ~= "." and root ~= "" then
            return { root }
        end
        return { "." }
    end

    error("babel plugin: no **/*.ts or **/*.tsx files found — add TypeScript sources or set source_dirs in configure()")
end

function M.resolve(ctx, cfg)
    local babel_config = cfg.babel_config
    if babel_config == nil then
        babel_config = M.find_babel_config(ctx)
    end

    local package_json = cfg.package_json
    if package_json == nil then
        package_json = M.find_package_json(ctx)
    end

    local root = cfg.project_root
    if root == nil then
        if package_json ~= nil then
            root = dirname(package_json)
        elseif babel_config ~= nil then
            root = dirname(babel_config)
        else
            root = "."
        end
    end

    local ts_files = M.find_typescript_files(ctx, root)
    if babel_config == nil and package_json == nil and #ts_files == 0 then
        error("babel plugin: no babel.config.*, package.json, or **/*.ts/**.tsx found — add a Babel/TypeScript project or set project_root in configure()")
    end

    if #ts_files == 0 then
        error("babel plugin: no **/*.ts or **/*.tsx files found — add TypeScript sources or set source_dirs in configure()")
    end

    local source_dirs = M.resolve_source_dirs(ctx, root, cfg.source_dirs)
    local build_dir = cfg.build_dir or "build/babel"
    local bin_dir = cfg.bin_dir or build_dir

    return {
        babel_config = babel_config,
        package_json = package_json,
        has_package_json = package_json ~= nil,
        project_root = root,
        source_dirs = source_dirs,
        ts_file_count = #ts_files,
        build_dir = build_dir,
        bin_dir = bin_dir,
        primary_output = bin_dir,
    }
end

return M
