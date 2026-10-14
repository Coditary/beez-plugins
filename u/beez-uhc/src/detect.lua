local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function module_name(path)
    return basename(path):gsub("%.hs$", "")
end

local function is_test_path(path)
    local lower = path:lower()
    if lower:match("/tests/") or lower:match("/test/") then
        return true
    end
    local name = basename(lower)
    return name:match("_test%.") ~= nil or name:match("^test_") ~= nil
end

function M.find_haskell_sources(ctx, root)
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local sources = ctx.glob({
        prefix .. "**/*.hs",
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
        prefix .. "tests/**/*.hs",
        prefix .. "test/**/*.hs",
        prefix .. "**/*_test.hs",
        prefix .. "**/test_*.hs",
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
        prefix .. "Main.hs",
        prefix .. "src/Main.hs",
        prefix .. "app/Main.hs",
        prefix .. "cmd/*/Main.hs",
    })

    if #candidates > 0 then
        table.sort(candidates)
        return candidates[1]
    end

    local sources = M.find_haskell_sources(ctx, root)
    for _, path in ipairs(sources) do
        if not is_test_path(path) then
            return path
        end
    end

    return nil
end

function M.resolve_build_targets(ctx, cfg)
    local root = cfg.project_root or "."
    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/uhc/bin"
    local entry = cfg.entry_point

    if entry == nil then
        entry = M.resolve_entry_point(ctx, root)
    end

    if entry == nil then
        error("uhc plugin: no Haskell entry point found — add Main.hs or set entry_point in configure()")
    end

    local targets = {
        {
            entry = entry,
            name = output_name,
            module = module_name(entry),
            output = bin_dir .. "/" .. output_name,
        },
    }

    return targets
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local sources = M.find_haskell_sources(ctx, root)
    if #sources == 0 then
        error("uhc plugin: no Haskell sources found — add *.hs files")
    end

    local project_root = cfg.project_root
    if project_root == nil then
        project_root = dirname(sources[1])
    end

    local targets = cfg.targets
    if targets == nil then
        targets = M.resolve_build_targets(ctx, {
            project_root = project_root,
            output_name = cfg.output_name,
            bin_dir = cfg.bin_dir,
            entry_point = cfg.entry_point,
        })
    end

    local bin_dir = cfg.bin_dir or "build/uhc/bin"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or cfg.output_name or "app")
        end
        if target.module == nil and target.entry ~= nil then
            target.module = module_name(target.entry)
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
        test_sources = test_sources,
    }
end

return M
