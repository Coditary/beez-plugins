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

function M.find_nimble(ctx)
    local files = ctx.glob({ "*.nimble", "**/*.nimble" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.project_root(nimble_path)
    if nimble_path == nil then
        return "."
    end
    return dirname(nimble_path)
end

function M.package_name(nimble_path)
    if nimble_path == nil then
        return "ctfe"
    end

    local name = basename(nimble_path):match("^(.+)%.nimble$")
    return name or "ctfe"
end

local function glob_prefix(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

function M.resolve_ctfe_targets(ctx, root, output_name)
    local prefix = glob_prefix(root)
    local targets = {}
    local seen = {}

    local candidates = {
        prefix .. "ctfe/main.nim",
        prefix .. "ctfe/eval.nim",
        prefix .. "src/ctfe.nim",
        prefix .. "ctfe.nim",
        prefix .. "src/main.nim",
        prefix .. "main.nim",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        for _, source in ipairs(matches) do
            if not seen[source] then
                seen[source] = true
                local name = basename(source):match("^(.+)%.nim$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    mode = "run",
                    output = nil,
                }
                break
            end
        end
        if #targets > 0 then
            break
        end
    end

    if #targets == 0 then
        local ctfe_files = ctx.glob({ prefix .. "ctfe/*.nim", prefix .. "**/ctfe_*.nim" })
        sort_shallow_first(ctfe_files)
        for _, source in ipairs(ctfe_files) do
            if not source:match("/tests/") and not source:match("/test/") then
                local name = basename(source):match("^(.+)%.nim$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    mode = "run",
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        local src_files = ctx.glob({ prefix .. "src/*.nim", prefix .. "*.nim" })
        sort_shallow_first(src_files)
        for _, source in ipairs(src_files) do
            if not source:match("/tests/") and not source:match("/test/") then
                local name = basename(source):match("^(.+)%.nim$") or output_name
                targets[#targets + 1] = {
                    source = source,
                    name = name,
                    mode = "run",
                    output = nil,
                }
                break
            end
        end
    end

    if #targets == 0 then
        error("nim-ctfe plugin: no .nim CTFE entry point found — add ctfe/main.nim or configure targets")
    end

    return targets
end

function M.resolve(ctx, cfg)
    local nimble_path = cfg.nimble_path
    if nimble_path == nil then
        nimble_path = M.find_nimble(ctx)
    end

    local nims = ctx.glob({ "**/*.nim" })
    if #nims == 0 then
        error("nim-ctfe plugin: no *.nim files found — add Nim sources or set targets in configure()")
    end

    local root = cfg.project_root or M.project_root(nimble_path)
    local output_name = cfg.output_name or M.package_name(nimble_path)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_ctfe_targets(ctx, root, output_name)
    end

    local out_dir = cfg.out_dir or "build/nim-ctfe/out"
    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = out_dir .. "/" .. (target.name or output_name)
        end
        if target.mode == nil then
            target.mode = "run"
        end
    end

    return {
        nimble_path = nimble_path,
        has_nimble = nimble_path ~= nil,
        project_root = root,
        package_name = output_name,
        targets = targets,
        out_dir = out_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
