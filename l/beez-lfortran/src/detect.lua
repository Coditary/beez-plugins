local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function is_test_path(path)
    local lower = path:lower()
    if lower:match("/tests/") or lower:match("/test/") then
        return true
    end
    local name = basename(lower)
    return name:match("_test%.") ~= nil or name:match("^test_") ~= nil
end

function M.find_fortran_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local sources = ctx.glob({
        prefix .. "**/*.f90",
        prefix .. "**/*.f95",
        prefix .. "**/*.f",
    })

    table.sort(sources)
    return sources
end

function M.find_test_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local tests = ctx.glob({
        prefix .. "tests/**/*.f90",
        prefix .. "tests/**/*.f95",
        prefix .. "tests/**/*.f",
        prefix .. "test/**/*.f90",
        prefix .. "test/**/*.f95",
        prefix .. "test/**/*.f",
        prefix .. "**/*_test.f90",
        prefix .. "**/*_test.f95",
        prefix .. "**/*_test.f",
        prefix .. "**/test_*.f90",
        prefix .. "**/test_*.f95",
        prefix .. "**/test_*.f",
    })

    local filtered = {}
    local seen = {}
    for _, path in ipairs(tests) do
        if not seen[path] then
            seen[path] = true
            filtered[#filtered + 1] = path
        end
    end

    table.sort(filtered)
    return filtered
end

function M.resolve_entry_point(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local candidates = ctx.glob({
        prefix .. "program.f90",
        prefix .. "main.f90",
        prefix .. "app.f90",
        prefix .. "src/program.f90",
        prefix .. "src/main.f90",
        prefix .. "src/app.f90",
        prefix .. "program.f95",
        prefix .. "main.f95",
        prefix .. "program.f",
        prefix .. "main.f",
    })

    if #candidates > 0 then
        table.sort(candidates)
        return candidates[1]
    end

    local sources = M.find_fortran_sources(ctx, root)
    for _, path in ipairs(sources) do
        if not is_test_path(path) then
            return path
        end
    end

    return nil
end

function M.collect_compile_sources(ctx, root, entry)
    local sources = {}
    local seen = {}

    for _, path in ipairs(M.find_fortran_sources(ctx, root)) do
        if not is_test_path(path) and not seen[path] then
            seen[path] = true
            sources[#sources + 1] = path
        end
    end

    if entry ~= nil and not seen[entry] then
        sources[#sources + 1] = entry
    end

    if entry ~= nil then
        table.sort(sources, function(a, b)
            if a == entry then return false end
            if b == entry then return true end
            return a < b
        end)
    end

    return sources
end

function M.resolve_build_targets(ctx, cfg)
    local root = cfg.project_root
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/lfortran/bin"
    local entry = cfg.entry_point

    if entry == nil then
        entry = M.resolve_entry_point(ctx, root)
    end

    if entry == nil then
        error("lfortran plugin: no Fortran entry point found — add *.f90 sources or set entry_point in configure()")
    end

    local sources = cfg.sources
    if sources == nil then
        sources = M.collect_compile_sources(ctx, root, entry)
    end

    local targets = {
        {
            entry = entry,
            sources = sources,
            name = output_name,
            output = bin_dir .. "/" .. output_name,
        },
    }

    return targets
end

function M.resolve(ctx, cfg)
    local sources = M.find_fortran_sources(ctx, cfg.project_root or ".")
    if #sources == 0 then
        error("lfortran plugin: no Fortran sources found — add *.f, *.f90, or *.f95 files")
    end

    local project_root = cfg.project_root or dirname(sources[1])
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, {
            project_root = project_root,
            output_name = cfg.output_name,
            bin_dir = cfg.bin_dir,
            entry_point = cfg.entry_point,
            sources = cfg.sources,
        })
    end

    local bin_dir = cfg.bin_dir or "build/lfortran/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or cfg.output_name or "app")
        end
    end

    local test_sources = cfg.test_sources
    if test_sources == nil then
        test_sources = M.find_test_sources(ctx, project_root)
    end

    return {
        project_root = project_root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_entry = targets[1].entry,
        compile_sources = targets[1].sources,
        test_sources = test_sources,
        target_name = targets[1].name,
    }
end

return M
