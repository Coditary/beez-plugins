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

local function is_test_path(path)
    return path:match("/test/") ~= nil
        or path:match("^test/") ~= nil
        or path:match("/tests/") ~= nil
        or path:match("^tests/") ~= nil
        or path:match("%.t%.sol$") ~= nil
end

function M.find_foundry_toml(ctx)
    local files = ctx.glob({ "foundry.toml", "**/foundry.toml" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(foundry_toml_path)
    if foundry_toml_path == nil then
        return "."
    end
    return dirname(foundry_toml_path)
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_compile_targets(ctx, root)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local matches = ctx.glob({ prefix .. "**/*.sol" })
    sort_shallow_first(matches)
    for _, source in ipairs(matches) do
        if not seen[source] and not is_test_path(source) then
            seen[source] = true
            local name = basename(source):match("^(.+)%.[^%.]+$") or basename(source)
            targets[#targets + 1] = {
                source = source,
                name = name,
                output = nil,
            }
        end
    end

    if #targets == 0 then
        error("solidity plugin: no .sol source files found — add contracts or set project_root in configure()")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local foundry_toml_path = cfg.foundry_toml_path
    if foundry_toml_path == nil then
        foundry_toml_path = M.find_foundry_toml(ctx)
    end

    local sol_files = ctx.glob({ "**/*.sol" })
    if foundry_toml_path == nil and #sol_files == 0 then
        error("solidity plugin: no foundry.toml or *.sol files found — add a Solidity project or set project_root in configure()")
    end

    local root = cfg.project_root or M.project_root(foundry_toml_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_compile_targets(ctx, root)
    end

    local bin_dir = cfg.bin_dir or "build/solidity"

    return {
        foundry_toml_path = foundry_toml_path,
        has_foundry_toml = foundry_toml_path ~= nil,
        project_root = root,
        package_name = targets[1].name,
        targets = targets,
        bin_dir = bin_dir,
        primary_source = targets[1].source,
    }
end

return M
