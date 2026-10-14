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

function M.find_project_marker(ctx)
    local markers = ctx.glob({
        "*.lpi",
        "*.dpr",
        "*.pas",
        "**/*.lpi",
        "**/*.dpr",
        "**/*.pas",
    })

    if #markers == 0 then
        return nil
    end

    table.sort(markers, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return markers[1]
end

function M.project_root(marker_path)
    return dirname(marker_path)
end

function M.resolve_build_targets(ctx, root)
    local prefix = prefix_for_root(root)
    local targets = {}
    local seen = {}

    local function add_target(source_path)
        if seen[source_path] then
            return
        end
        seen[source_path] = true

        local name = stem(source_path)
        targets[#targets + 1] = {
            source = relative_to_root(source_path, root),
            name = name,
            output = nil,
        }
    end

    for _, path in ipairs(ctx.glob({ prefix .. "*.dpr", prefix .. "**/*.dpr" })) do
        add_target(path)
    end

    for _, path in ipairs(ctx.glob({ prefix .. "*.lpr", prefix .. "**/*.lpr" })) do
        add_target(path)
    end

    for _, lpi_path in ipairs(ctx.glob({ prefix .. "*.lpi", prefix .. "**/*.lpi" })) do
        local lpr_path = lpi_path:gsub("%.lpi$", ".lpr")
        local lpr_matches = ctx.glob({ lpr_path })
        if #lpr_matches > 0 then
            add_target(lpr_matches[1])
        end
    end

    if #targets == 0 then
        for _, path in ipairs(ctx.glob({ prefix .. "*.pas" })) do
            add_target(path)
            break
        end
    end

    if #targets == 0 then
        targets[#targets + 1] = {
            source = prefix .. "program.pas",
            name = "app",
            output = nil,
        }
    end

    return targets
end

function M.resolve_test_runner(ctx, root)
    local prefix = prefix_for_root(root)
    local candidates = ctx.glob({
        prefix .. "tests/testrunner.lpr",
        prefix .. "tests/testrunner.dpr",
        prefix .. "tests/testrunner.pas",
        prefix .. "test/testrunner.lpr",
        prefix .. "test/testrunner.dpr",
        prefix .. "test/testrunner.pas",
        prefix .. "**/testrunner.lpr",
        prefix .. "**/testrunner.dpr",
        prefix .. "**/testrunner.pas",
    })

    if #candidates == 0 then
        return nil
    end

    table.sort(candidates)
    return candidates[1]
end

function M.resolve(ctx, cfg)
    local marker = cfg.project_marker or M.find_project_marker(ctx)
    if marker == nil then
        error("fpc plugin: no Pascal project found — add *.lpi, *.dpr, or *.pas files")
    end

    local root = cfg.project_root or M.project_root(marker)
    local targets = cfg.targets

    if targets == nil then
        targets = M.resolve_build_targets(ctx, root)
    end

    local output_name = cfg.output_name or "app"
    local bin_dir = cfg.bin_dir or "build/fpc/bin"

    for _, target in ipairs(targets) do
        if target.output == nil then
            target.output = bin_dir .. "/" .. (target.name or output_name)
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
