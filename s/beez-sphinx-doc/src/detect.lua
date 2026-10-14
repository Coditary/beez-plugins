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
    local dir = path:match("^(.*)/[^/]+$")
    if dir == nil or dir == "" then
        return "."
    end
    return dir
end

function M.resolve_conf(ctx, root, cfg_conf)
    if cfg_conf ~= nil and cfg_conf ~= "" then
        return cfg_conf, dirname(cfg_conf)
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local conf_files = ctx.glob({
        prefix .. "/conf.py",
        prefix .. "/**/conf.py",
    })

    sort_shallow_first(conf_files)

    if #conf_files > 0 then
        local conf = conf_files[1]
        return conf, dirname(conf)
    end

    return nil, nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/tests/**/*.rst",
        prefix .. "/test/**/*.rst",
        prefix .. "/**/test_*.rst",
        prefix .. "/**/*_test.rst",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local conf_py, source_dir = M.resolve_conf(ctx, root, cfg.conf_py)
    local rst_files = ctx.glob({ "**/*.rst" })

    if conf_py == nil and #rst_files == 0 then
        error("sphinx-doc plugin: no conf.py or *.rst files found — add a Sphinx project or set conf_py in configure()")
    end

    if source_dir == nil then
        source_dir = root
    end

    local bin_dir = cfg.bin_dir or "build/sphinx-doc/html"
    local output_name = cfg.output_name or "index.html"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        conf_py = conf_py,
        source_dir = source_dir,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
