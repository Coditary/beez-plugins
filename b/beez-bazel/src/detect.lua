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

function M.has_workspace(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local workspaces = ctx.glob({
        prefix .. "/WORKSPACE",
        prefix .. "/WORKSPACE.bazel",
        prefix .. "/**/WORKSPACE",
        prefix .. "/**/WORKSPACE.bazel",
        prefix .. "/MODULE.bazel",
    })

    return #workspaces > 0
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local workspace = ctx.glob({
        prefix .. "/WORKSPACE",
        prefix .. "/WORKSPACE.bazel",
        prefix .. "/MODULE.bazel",
    })
    if #workspace > 0 then
        sort_shallow_first(workspace)
        return workspace[1]
    end

    local build_file = ctx.glob({
        prefix .. "/BUILD",
        prefix .. "/BUILD.bazel",
        prefix .. "/**/BUILD",
        prefix .. "/**/BUILD.bazel",
    })
    if #build_file > 0 then
        sort_shallow_first(build_file)
        return build_file[1]
    end

    return nil
end

function M.has_tests(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local test_builds = ctx.glob({
        prefix .. "/test/**/BUILD",
        prefix .. "/test/**/BUILD.bazel",
        prefix .. "/tests/**/BUILD",
        prefix .. "/tests/**/BUILD.bazel",
    })

    return #test_builds > 0
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local bazel_files = ctx.glob({
        "BUILD",
        "BUILD.bazel",
        "WORKSPACE",
        "WORKSPACE.bazel",
        "**/BUILD",
        "**/BUILD.bazel",
    })

    if entry_source == nil and #bazel_files == 0 then
        error("bazel plugin: no BUILD, BUILD.bazel, or WORKSPACE files found — add Bazel sources or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/bazel/bin"
    local output_name = cfg.output_name or "build.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local has_workspace = cfg.has_workspace
    if has_workspace == nil then
        has_workspace = M.has_workspace(ctx, root)
    end
    local has_tests = cfg.has_tests
    if has_tests == nil then
        has_tests = M.has_tests(ctx, root)
    end

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        has_workspace = has_workspace,
        has_tests = has_tests,
    }
end

return M
