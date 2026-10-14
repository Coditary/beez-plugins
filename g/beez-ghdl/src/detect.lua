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

local function entity_name(path)
    local base = path:match("([^/]+)$") or path
    return (base:gsub("%.vhd%l?$", ""))
end

function M.collect_sources(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*.vhdl",
        prefix .. "/**/*.vhd",
        prefix .. "/*.vhdl",
        prefix .. "/*.vhd",
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

function M.resolve_top_entity(sources, cfg_top)
    if cfg_top ~= nil and cfg_top ~= "" then
        return cfg_top
    end

    for _, source in ipairs(sources) do
        if not is_testbench(source) then
            return entity_name(source)
        end
    end

    if #sources > 0 then
        return entity_name(sources[1])
    end

    return "app"
end

function M.has_testbench(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_files = ctx.glob({
        prefix .. "/**/*_tb.vhd",
        prefix .. "/**/*_tb.vhdl",
        prefix .. "/**/tb_*.vhd",
        prefix .. "/**/tb_*.vhdl",
        prefix .. "/**/test_*.vhd",
        prefix .. "/**/test_*.vhdl",
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
        error("ghdl plugin: no *.vhd or *.vhdl files found — add a VHDL project or set project_root in configure()")
    end

    local top_entity = M.resolve_top_entity(sources, cfg.top_entity)
    local bin_dir = cfg.bin_dir or "build/ghdl/bin"
    local output_name = cfg.output_name or "app"
    local primary_output = bin_dir .. "/" .. output_name
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_testbench(ctx, root)
    end

    return {
        project_root = root,
        sources = sources,
        top_entity = top_entity,
        bin_dir = bin_dir,
        work_dir = cfg.work_dir or "build/ghdl/work",
        output_name = output_name,
        primary_output = primary_output,
        has_tests = has_tests,
    }
end

return M
