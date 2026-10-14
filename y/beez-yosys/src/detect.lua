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

local function is_testbench(path)
    return path:match("_tb%.") ~= nil
        or path:match("/tb[_/]") ~= nil
        or path:match("/test[_/]") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("testbench") ~= nil
end

local function module_name(path)
    local base = path:match("([^/]+)$") or path
    return (base:gsub("%.s?v$", ""))
end

function M.collect_sources(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*.v",
        prefix .. "/**/*.sv",
        prefix .. "/*.v",
        prefix .. "/*.sv",
    })

    sort_shallow_first(files)

    local sources = {}
    local seen = {}
    for _, file in ipairs(files) do
        if not seen[file] then
            seen[file] = true
            sources[#sources + 1] = file
        end
    end

    return sources
end

function M.resolve_top_module(sources, cfg_top)
    if cfg_top ~= nil and cfg_top ~= "" then
        return cfg_top
    end

    for _, source in ipairs(sources) do
        if not is_testbench(source) then
            return module_name(source)
        end
    end

    if #sources > 0 then
        return module_name(sources[1])
    end

    return "top"
end

function M.has_testbench(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/**/*_tb.v",
        prefix .. "/**/*_tb.sv",
        prefix .. "/**/tb_*.v",
        prefix .. "/**/tb_*.sv",
    })

    return #test_files > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local sources = cfg.sources
    if sources == nil then
        sources = M.collect_sources(ctx, root)
    end

    if #sources == 0 then
        error("yosys plugin: no *.v or *.sv files found — add Verilog sources or set project_root in configure()")
    end

    local top_module = M.resolve_top_module(sources, cfg.top_module)
    local bin_dir = cfg.bin_dir or "build/yosys/bin"
    local output_name = cfg.output_name or "synth.v"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_testbench(ctx, root)
    end

    return {
        project_root = root,
        sources = sources,
        top_module = top_module,
        top_source = sources[1],
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
