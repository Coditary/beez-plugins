local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function relative_path(cfg, path)
    if path == nil then
        return nil
    end

    if cfg.project_root == "." or cfg.project_root == "" then
        return path
    end

    local prefix = cfg.project_root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return path
end

local function quoted_project_file(cfg)
    if cfg.project_file == nil then
        return ""
    end

    return beez.char.quote(relative_path(cfg, cfg.project_file))
end

local function build_output_dir(cfg, root)
    return root .. "/" .. cfg.bin_dir
end

local function obj_output_dir(cfg, root)
    return root .. "/" .. cfg.obj_dir
end

local function ensure_build_dirs(cfg, root)
    return table.concat({
        "mkdir -p " .. beez.char.quote(build_output_dir(cfg, root)),
        "&&",
        "mkdir -p " .. beez.char.quote(obj_output_dir(cfg, root)),
    }, " ")
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.oxygene-setup"
end

local function unit_paths_arg(cfg)
    if cfg.unit_paths == nil or #cfg.unit_paths == 0 then
        return ""
    end

    local paths = {}
    for _, unit_path in ipairs(cfg.unit_paths) do
        paths[#paths + 1] = beez.char.quote(unit_path)
    end

    return "-unitpaths:" .. table.concat(paths, ";")
end

function M.setup(cfg, root)
    local stamp = setup_stamp(cfg, root)
    return table.concat({
        ensure_build_dirs(cfg, root),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build(cfg, root)
    if cfg.toolchain == "msbuild" then
        
function M.run(cfg, root)
    local run_args = beez.env_or("BEEZ_RUN_ARGS", cfg.run_args or "")

    if cfg.run_command ~= nil and cfg.run_command ~= "" then
        if run_args ~= "" then
            return cfg.run_command .. " " .. run_args
        end
        return cfg.run_command
    end

    if cfg.primary_source ~= nil then
        local interpreter = cfg.interpreter_binary
        if interpreter == nil or interpreter == "" then
            error("run: primary_source set but no interpreter_binary in config")
        end
        local parts = {}
        if cfg.project_root ~= nil and cfg.project_root ~= "." and cfg.project_root ~= "" then
            parts[#parts + 1] = "cd " .. beez.char.quote(root .. "/" .. cfg.project_root)
            parts[#parts + 1] = "&&"
        end
        parts[#parts + 1] = interpreter
        parts[#parts + 1] = cfg.primary_source
        if run_args ~= "" then
            parts[#parts + 1] = run_args
        end
        return table.concat(parts, " ")
    end

    if cfg.primary_output ~= nil then
        local exe = root .. "/" .. cfg.primary_output
        local parts = {
            "(",
            "test -x " .. beez.char.quote(exe),
            "||",
            "test -f " .. beez.char.quote(exe),
            ")",
            "&&",
            beez.char.quote(exe),
        }
        if run_args ~= "" then
            parts[#parts + 1] = run_args
        end
        return table.concat(parts, " ")
    end

    if cfg.build_tree ~= nil then
        local bin_dir = root .. "/" .. cfg.build_tree .. "/bin"
        local shell = "set -e; bin=$(find "
            .. beez.char.quote(bin_dir)
            .. " -type f \\( -perm -111 -o -name '*.wasm' -o -name '*.js' \\) 2>/dev/null | head -n1); "
            .. "if [ -z \"$bin\" ]; then echo 'run: no executable in "
            .. cfg.build_tree
            .. "/bin' >&2; exit 1; fi; exec \"$bin\""
        if run_args ~= "" then
            shell = shell .. " " .. run_args
        end
        return "sh -c " .. beez.char.quote(shell)
    end

    error("run: no run target configured")
end

return M.build_msbuild(cfg, root)
    end

    return M.build_elements(cfg, root)
end

function M.build_msbuild(cfg, root)
    local parts = {
        ensure_build_dirs(cfg, root),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.msbuild_binary,
        quoted_project_file(cfg),
        "/p:Configuration=" .. beez.char.quote(cfg.configuration),
        "/p:Platform=" .. beez.char.quote(cfg.platform),
        "/p:OutputPath=" .. beez.char.quote(build_output_dir(cfg, root)),
        "/p:OutDir=" .. beez.char.quote(build_output_dir(cfg, root)),
        "/p:IntermediateOutputPath=" .. beez.char.quote(obj_output_dir(cfg, root)),
    }

    if cfg.elements_target ~= nil and cfg.elements_target ~= "" then
        parts[#parts + 1] = "/p:ElementsTarget=" .. beez.char.quote(cfg.elements_target)
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.build_elements(cfg, root)
    local output = build_output_dir(cfg, root) .. "/" .. cfg.output_name
    local parts = {
        ensure_build_dirs(cfg, root),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.elements_binary,
        "-o",
        beez.char.quote(output),
    }

    local unit_arg = unit_paths_arg(cfg)
    if unit_arg ~= "" then
        parts[#parts + 1] = unit_arg
    end

    if cfg.elements_target ~= nil and cfg.elements_target ~= "" then
        parts[#parts + 1] = "-target:" .. beez.char.quote(cfg.elements_target)
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    for _, source in ipairs(cfg.source_files) do
        parts[#parts + 1] = beez.char.quote(relative_path(cfg, source))
    end

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    return "test -d " .. beez.char.quote(build_output_dir(cfg, root))
end

function M.test(cfg, root)
    if cfg.test_elements ~= nil then
        return M.test_msbuild(cfg, root)
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/oxygene-" .. cfg.profile_name .. ".ok"),
    }, " ")
end

function M.test_msbuild(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.msbuild_binary,
        beez.char.quote(relative_path(cfg, cfg.test_elements)),
        "/p:Configuration=" .. beez.char.quote(cfg.configuration),
        "/p:Platform=" .. beez.char.quote(cfg.platform),
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    return table.concat(parts, " ")
end

return M
