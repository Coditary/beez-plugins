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

local function is_test_source(path)
    local lower = path:lower()
    if lower:match("/tests/") or lower:match("/test/") then
        return true
    end
    if lower:match("test") then
        return true
    end
    return false
end

function M.is_fortran_source(path)
    local lower = path:lower()
    return lower:match("%.f90$") ~= nil
        or lower:match("%.f95$") ~= nil
        or lower:match("%.f$") ~= nil
end

function M.is_c_source(path)
    return path:lower():match("%.c$") ~= nil
end

function M.compiler_for_sources(sources, cfg)
    for _, source_path in ipairs(sources) do
        if M.is_fortran_source(source_path) then
            return cfg.openf90_binary
        end
    end
    return cfg.opencc_binary
end

function M.find_fortran_sources(ctx)
    local sources = ctx.glob({ "**/*.f", "**/*.f90", "**/*.f95" })
    table.sort(sources)
    return sources
end

function M.find_c_sources(ctx)
    local sources = ctx.glob({ "**/*.c" })
    table.sort(sources)
    return sources
end

function M.find_all_sources(ctx)
    local sources = ctx.glob({ "**/*.f", "**/*.f90", "**/*.f95", "**/*.c" })
    table.sort(sources)
    return sources
end

function M.find_cmake_lists(ctx)
    local manifests = ctx.glob({ "CMakeLists.txt", "**/CMakeLists.txt" })
    if #manifests == 0 then
        return nil
    end
    table.sort(manifests)
    return manifests[1]
end

function M.find_makefile(ctx)
    local makefiles = ctx.glob({ "Makefile", "makefile", "**/Makefile", "**/makefile" })
    if #makefiles == 0 then
        return nil
    end
    table.sort(makefiles)
    return makefiles[1]
end

function M.has_project_markers(ctx)
    return M.find_cmake_lists(ctx) ~= nil
        or M.find_makefile(ctx) ~= nil
        or #M.find_all_sources(ctx) > 0
end

function M.resolve_project_root(sources, cmake_lists, makefile)
    if cmake_lists ~= nil then
        return dirname(cmake_lists)
    end
    if makefile ~= nil then
        return dirname(makefile)
    end
    if #sources == 0 then
        return "."
    end

    local shallowest = sources[1]
    local shallowest_depth = select(2, shallowest:gsub("/", ""))

    for i = 2, #sources do
        local depth = select(2, sources[i]:gsub("/", ""))
        if depth < shallowest_depth then
            shallowest = sources[i]
            shallowest_depth = depth
        end
    end

    return dirname(shallowest)
end

function M.collect_sources_for_main(ctx, main_path)
    local main_dir = dirname(main_path)
    local prefix = (main_dir ~= "." and main_dir ~= "") and (main_dir .. "/") or ""
    local is_fortran = M.is_fortran_source(main_path)

    local patterns
    if is_fortran then
        patterns = {
            prefix .. "*.f",
            prefix .. "*.f90",
            prefix .. "*.f95",
            prefix .. "**/*.f",
            prefix .. "**/*.f90",
            prefix .. "**/*.f95",
        }
    else
        patterns = {
            prefix .. "*.c",
            prefix .. "**/*.c",
        }
    end

    local sources = ctx.glob(patterns)
    if #sources == 0 then
        return { main_path }
    end

    local filtered = {}
    local seen = {}
    for _, source_path in ipairs(sources) do
        if not is_test_source(source_path) and not seen[source_path] then
            seen[source_path] = true
            filtered[#filtered + 1] = source_path
        end
    end

    table.sort(filtered)
    if #filtered == 0 then
        return { main_path }
    end
    return filtered
end

function M.resolve_plain_targets(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local preferred = ctx.glob({
        prefix .. "main.f90",
        prefix .. "main.f95",
        prefix .. "main.f",
        prefix .. "program.f90",
        prefix .. "program.f95",
        prefix .. "program.f",
        prefix .. "src/main.f90",
        prefix .. "src/main.f95",
        prefix .. "src/main.f",
        prefix .. "cmd/*/main.f90",
        prefix .. "cmd/*/main.f95",
        prefix .. "cmd/*/main.f",
        prefix .. "main.c",
        prefix .. "src/main.c",
        prefix .. "cmd/*/main.c",
    })

    local targets = {}
    local seen = {}

    for _, main_path in ipairs(preferred) do
        if not is_test_source(main_path) and not seen[main_path] then
            seen[main_path] = true
            local name = stem(main_path)
            if main_path:match("/cmd/") then
                name = basename(dirname(main_path))
            end
            local sources = M.collect_sources_for_main(ctx, main_path)
            targets[#targets + 1] = {
                kind = "plain",
                name = name,
                sources = sources,
                compiler = nil,
                output = nil,
            }
        end
    end

    if #targets == 0 then
        local all_sources = M.find_all_sources(ctx)
        local non_test = {}
        for _, source_path in ipairs(all_sources) do
            if not is_test_source(source_path) then
                non_test[#non_test + 1] = source_path
            end
        end

        if #non_test == 1 then
            targets[#targets + 1] = {
                kind = "plain",
                name = stem(non_test[1]),
                sources = { non_test[1] },
                compiler = nil,
                output = nil,
            }
        elseif #non_test > 1 then
            local fortran = {}
            local c_sources = {}
            for _, source_path in ipairs(non_test) do
                if M.is_fortran_source(source_path) then
                    fortran[#fortran + 1] = source_path
                elseif M.is_c_source(source_path) then
                    c_sources[#c_sources + 1] = source_path
                end
            end

            if #fortran > 0 then
                targets[#targets + 1] = {
                    kind = "plain",
                    name = "app",
                    sources = fortran,
                    compiler = nil,
                    output = nil,
                }
            end
            if #c_sources > 0 then
                targets[#targets + 1] = {
                    kind = "plain",
                    name = (#fortran > 0) and "app_c" or "app",
                    sources = c_sources,
                    compiler = nil,
                    output = nil,
                }
            end
        end
    end

    return targets
end

function M.resolve_test_targets(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local tests = ctx.glob({
        prefix .. "tests/**/*.f",
        prefix .. "tests/**/*.f90",
        prefix .. "tests/**/*.f95",
        prefix .. "tests/**/*.c",
        prefix .. "test/**/*.f",
        prefix .. "test/**/*.f90",
        prefix .. "test/**/*.f95",
        prefix .. "test/**/*.c",
        prefix .. "**/*test*.f",
        prefix .. "**/*test*.f90",
        prefix .. "**/*test*.f95",
        prefix .. "**/*test*.c",
        prefix .. "**/*_test.f",
        prefix .. "**/*_test.f90",
        prefix .. "**/*_test.f95",
        prefix .. "**/*_test.c",
    })

    local targets = {}
    local seen = {}

    table.sort(tests)
    for _, source_path in ipairs(tests) do
        if not seen[source_path] then
            seen[source_path] = true
            targets[#targets + 1] = {
                kind = "plain",
                name = "test_" .. stem(source_path),
                sources = { source_path },
                compiler = nil,
                output = nil,
            }
        end
    end

    return targets
end

function M.resolve_build_targets(ctx, root, cfg)
    local cmake_lists = cfg.cmake_lists
    local makefile = cfg.makefile
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/open64/bin"
    local all_sources = M.find_all_sources(ctx)

    if cmake_lists ~= nil and #all_sources == 0 then
        return {
            {
                kind = "cmake",
                name = output_name,
                cmake_lists = cmake_lists,
                output = bin_dir .. "/" .. output_name,
            },
        }
    end

    if makefile ~= nil and #all_sources == 0 then
        return {
            {
                kind = "makefile",
                name = output_name,
                makefile = makefile,
                output = bin_dir .. "/" .. output_name,
            },
        }
    end

    return M.resolve_plain_targets(ctx, root)
end

function M.resolve(ctx, cfg)
    cfg = cfg or {}

    local fortran_sources = M.find_fortran_sources(ctx)
    local c_sources = M.find_c_sources(ctx)
    local all_sources = M.find_all_sources(ctx)
    local cmake_lists = cfg.cmake_lists or M.find_cmake_lists(ctx)
    local makefile = cfg.makefile or M.find_makefile(ctx)

    if #all_sources == 0 and cmake_lists == nil and makefile == nil then
        error("open64 plugin: no Fortran/C sources or build markers found — add **/*.f, **/*.f90, **/*.f95, **/*.c, CMakeLists.txt, or Makefile")
    end

    local root = cfg.project_root or M.resolve_project_root(all_sources, cmake_lists, makefile)
    local bin_dir = cfg.bin_dir or "build/open64/bin"
    local targets = cfg.targets or M.resolve_build_targets(ctx, root, {
        cmake_lists = cmake_lists,
        makefile = makefile,
        output_name = cfg.output_name,
        bin_dir = bin_dir,
    })

    if #targets == 0 then
        error("open64 plugin: no Open64 build targets resolved")
    end

    local test_targets = cfg.test_targets
    if test_targets == nil then
        test_targets = M.resolve_test_targets(ctx, root)
    end

    local resolve_cfg = {
        openf90_binary = cfg.openf90_binary or "openf90",
        opencc_binary = cfg.opencc_binary or "opencc",
    }

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or cfg.output_name or "app")
        end
        if target.kind == "plain" and target.compiler == nil then
            target.compiler = M.compiler_for_sources(target.sources, resolve_cfg)
        end
    end

    for _, target in ipairs(test_targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name
        end
        if target.compiler == nil then
            target.compiler = M.compiler_for_sources(target.sources, resolve_cfg)
        end
    end

    return {
        project_root = root,
        fortran_sources = fortran_sources,
        c_sources = c_sources,
        sources = all_sources,
        cmake_lists = cmake_lists,
        makefile = makefile,
        targets = targets,
        test_targets = test_targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        build_kind = targets[1].kind,
    }
end

return M
