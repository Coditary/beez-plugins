local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
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

local function read_file(path)
    local file = io.open(path, "r")
    if file == nil then
        return nil
    end

    local content = file:read("*a")
    file:close()
    return content
end

local function system_name_from_asd(asd_path)
    local content = read_file(asd_path)
    if content == nil then
        return nil
    end

    local name = content:match('defsystem%s+["\']([^"\']+)["\']')
    if name == nil then
        name = content:match("defsystem%s+(%S+)")
    end

    return name
end

local function build_pathname_from_asd(asd_path)
    local content = read_file(asd_path)
    if content == nil then
        return nil
    end

    return content:match(':build%-pathname%s+["\']([^"\']+)["\']')
end

function M.find_asd_file(ctx)
    local files = ctx.glob({ "*.asd", "**/*.asd" })
    if #files == 0 then
        return nil
    end

    sort_shallow_first(files)
    return files[1]
end

function M.find_build_script(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local candidates = {
        prefix .. "build.lisp",
        prefix .. "build.cl",
        prefix .. "build",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    return nil
end

function M.find_test_script(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local candidates = {
        prefix .. "test.lisp",
        prefix .. "test.cl",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    return nil
end

function M.find_entry_lisp(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    end

    local candidates = {
        prefix .. "main.lisp",
        prefix .. "src/main.lisp",
        prefix .. "main.cl",
        prefix .. "src/main.cl",
    }

    for _, pattern in ipairs(candidates) do
        local matches = ctx.glob({ pattern })
        if #matches > 0 then
            sort_shallow_first(matches)
            return matches[1]
        end
    end

    return nil
end

function M.resolve_executables(asd_path, system_name)
    local outputs = {}

    if asd_path ~= nil then
        local build_path = build_pathname_from_asd(asd_path)
        if build_path ~= nil then
            outputs[#outputs + 1] = basename(build_path)
        end
    end

    if #outputs == 0 and system_name ~= nil then
        outputs[#outputs + 1] = system_name:lower():gsub("_", "-")
    end

    if #outputs == 0 then
        outputs[#outputs + 1] = "app"
    end

    return outputs
end

function M.resolve(ctx, cfg)
    local asd_files = ctx.glob({ "*.asd", "**/*.asd" })
    local lisp_files = ctx.glob({ "**/*.lisp", "**/*.cl" })

    if #asd_files == 0 and #lisp_files == 0 then
        error("sbcl plugin: no *.asd or **/*.lisp/**/*.cl files found — add Common Lisp sources or set build_script in configure()")
    end

    local asd_file = cfg.asd_file or M.find_asd_file(ctx)
    local project_root = cfg.project_root or "."
    if asd_file ~= nil then
        project_root = dirname(asd_file)
    end

    local system_name = cfg.system_name
    if system_name == nil and asd_file ~= nil then
        system_name = system_name_from_asd(asd_file)
    end
    system_name = system_name or "app"

    local build_script = cfg.build_script or M.find_build_script(ctx, project_root)
    if build_script == nil then
        build_script = M.find_entry_lisp(ctx, project_root)
    end
    if build_script == nil then
        error("sbcl plugin: no build script found — add build.lisp or set build_script in configure()")
    end

    local test_script = cfg.test_script or M.find_test_script(ctx, project_root)
    local bin_dir = cfg.bin_dir or "build/sbcl/bin"
    local executables = cfg.executables
    if executables == nil then
        executables = M.resolve_executables(asd_file, system_name)
    end

    local outputs = {}
    for _, name in ipairs(executables) do
        outputs[#outputs + 1] = bin_dir .. "/" .. name
    end

    return {
        asd_file = asd_file,
        project_root = project_root,
        system_name = system_name,
        build_script = build_script,
        test_script = test_script,
        executables = executables,
        bin_dir = bin_dir,
        primary_output = outputs[1],
        artifact_globs = {
            bin_dir .. "/**",
        },
    }
end

return M
