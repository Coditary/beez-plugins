local M = {}

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function stem(path)
    return basename(path):match("^(.+)%.[^%.]+$") or basename(path)
end

local function prefix_for_root(root)
    if root ~= "." and root ~= "" then
        return root .. "/"
    end
    return ""
end

local function relative_to_root(path, root)
    if root == "." or root == "" then
        return path
    end

    local prefix = root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return path
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

function M.find_project_marker(ctx)
    local vpj_markers = ctx.glob({ "*.vpj", "**/*.vpj" })
    if #vpj_markers > 0 then
        sort_shallow_first(vpj_markers)
        return vpj_markers[1]
    end

    local pas_markers = ctx.glob({ "*.pas", "**/*.pas" })
    if #pas_markers > 0 then
        sort_shallow_first(pas_markers)
        return pas_markers[1]
    end

    return nil
end

function M.project_root(marker_path)
    return dirname(marker_path)
end

function M.resolve_build_targets(ctx, root)
    local prefix = prefix_for_root(root)
    local targets = {}
    local seen = {}

    local function add_target(source_path, kind)
        if seen[source_path] then
            return
        end
        seen[source_path] = true

        local name = stem(source_path)
        targets[#targets + 1] = {
            source = relative_to_root(source_path, root),
            name = name,
            kind = kind,
            output = nil,
        }
    end

    for _, path in ipairs(ctx.glob({ prefix .. "*.vpj", prefix .. "**/*.vpj" })) do
        add_target(path, "vpj")
    end

    if #targets == 0 then
        for _, path in ipairs(ctx.glob({ prefix .. "*.dpr", prefix .. "**/*.dpr" })) do
            add_target(path, "dpr")
        end
    end

    if #targets == 0 then
        for _, path in ipairs(ctx.glob({ prefix .. "*.pas", prefix .. "**/*.pas" })) do
            add_target(path, "pas")
            break
        end
    end

    if #targets == 0 then
        targets[#targets + 1] = {
            source = "program.pas",
            name = "app",
            kind = "pas",
            output = nil,
        }
    end

    return targets
end

function M.resolve_test_runner(ctx, root)
    local prefix = prefix_for_root(root)
    local candidates = ctx.glob({
        prefix .. "tests/testrunner.dpr",
        prefix .. "tests/testrunner.pas",
        prefix .. "test/testrunner.dpr",
        prefix .. "test/testrunner.pas",
        prefix .. "**/testrunner.dpr",
        prefix .. "**/testrunner.pas",
    })

    if #candidates == 0 then
        return nil
    end

    sort_shallow_first(candidates)
    return candidates[1]
end

function M.resolve(ctx, cfg)
    local marker = cfg.project_marker or M.find_project_marker(ctx)
    if marker == nil then
        error("virtual-pascal plugin: no Pascal project found — add *.vpj or **/*.pas files")
    end

    local root = cfg.project_root or M.project_root(marker)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/virtual-pascal/bin"

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name) .. ".exe"
        end
    end

    local test_runner = cfg.test_runner or M.resolve_test_runner(ctx, root)
    if test_runner ~= nil then
        test_runner = relative_to_root(test_runner, root)
    end

    return {
        project_marker = marker,
        project_root = root,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
        test_runner = test_runner,
    }
end

return M
