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

function M.find_sources(ctx)
    local sources = ctx.glob({ "**/*.f", "**/*.f90", "**/*.f95" })
    table.sort(sources)
    return sources
end

function M.resolve_project_root(sources)
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

function M.resolve_build_targets(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local preferred = ctx.glob({
        prefix .. "main.f",
        prefix .. "main.f90",
        prefix .. "main.f95",
        prefix .. "program.f",
        prefix .. "program.f90",
        prefix .. "program.f95",
        prefix .. "src/main.f",
        prefix .. "src/main.f90",
        prefix .. "src/main.f95",
        prefix .. "cmd/*/main.f",
        prefix .. "cmd/*/main.f90",
        prefix .. "cmd/*/main.f95",
    })

    local targets = {}
    local seen = {}

    for _, source_path in ipairs(preferred) do
        if not is_test_source(source_path) and not seen[source_path] then
            seen[source_path] = true
            local name = stem(source_path)
            if source_path:match("/cmd/") then
                name = basename(dirname(source_path))
            end
            targets[#targets + 1] = {
                source = source_path,
                name = name,
                output = nil,
            }
        end
    end

    if #targets == 0 then
        local all_sources = M.find_sources(ctx)
        local non_test = {}
        for _, source_path in ipairs(all_sources) do
            if not is_test_source(source_path) then
                non_test[#non_test + 1] = source_path
            end
        end

        if #non_test == 1 then
            targets[#targets + 1] = {
                source = non_test[1],
                name = stem(non_test[1]),
                output = nil,
            }
        elseif #non_test > 1 then
            for _, source_path in ipairs(non_test) do
                if not seen[source_path] then
                    seen[source_path] = true
                    targets[#targets + 1] = {
                        source = source_path,
                        name = stem(source_path),
                        output = nil,
                    }
                end
            end
        end
    end

    if #targets == 0 then
        error("g95 plugin: no Fortran source files found — add **/*.f, **/*.f90, or **/*.f95")
    end

    return targets
end

function M.resolve_test_targets(ctx, root)
    local prefix = (root ~= "." and root ~= "") and (root .. "/") or ""

    local tests = ctx.glob({
        prefix .. "tests/**/*.f",
        prefix .. "tests/**/*.f90",
        prefix .. "tests/**/*.f95",
        prefix .. "test/**/*.f",
        prefix .. "test/**/*.f90",
        prefix .. "test/**/*.f95",
        prefix .. "**/*test*.f",
        prefix .. "**/*test*.f90",
        prefix .. "**/*test*.f95",
        prefix .. "**/*_test.f",
        prefix .. "**/*_test.f90",
        prefix .. "**/*_test.f95",
    })

    local targets = {}
    local seen = {}

    table.sort(tests)
    for _, source_path in ipairs(tests) do
        if not seen[source_path] then
            seen[source_path] = true
            targets[#targets + 1] = {
                source = source_path,
                name = "test_" .. stem(source_path),
                output = nil,
            }
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local sources = M.find_sources(ctx)
    if #sources == 0 then
        error("g95 plugin: no Fortran source files found — add **/*.f, **/*.f90, or **/*.f95")
    end

    local root = cfg.project_root or M.resolve_project_root(sources)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    local test_targets = cfg.test_targets
    if test_targets == nil then
        test_targets = M.resolve_test_targets(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/g95/bin"

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
        end
    end

    for _, target in ipairs(test_targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. target.name
        end
    end

    return {
        project_root = root,
        sources = sources,
        targets = targets,
        test_targets = test_targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
