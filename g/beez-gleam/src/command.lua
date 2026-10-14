local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function copy_beams_to_ebin(ebin_dir)
    return table.concat({
        "mkdir -p " .. beez.char.quote(ebin_dir),
        "&&",
        "find build -path '*/ebin/*.beam' ! -path "
            .. beez.char.quote(ebin_dir) .. "/*",
        "-exec cp -f {} " .. beez.char.quote(ebin_dir) .. "/ \\;",
    }, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.gleam-setup"

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        cfg.gleam_binary,
        "deps",
        "download",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.gleam_binary,
        "build",
        "--target",
        cfg.build_target,
    }

    if cfg.build_mode_flag ~= nil and cfg.build_mode_flag ~= "" then
        parts[#parts + 1] = "--mode"
        parts[#parts + 1] = cfg.build_mode_flag
    end

    for _, arg in ipairs(cfg.build_args) do
        parts[#parts + 1] = arg
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = copy_beams_to_ebin(cfg.ebin_dir)

    return table.concat(parts, " ")
end

function M.verify_beams(cfg, root)
    return "test -d " .. beez.char.quote(root .. "/" .. cfg.ebin_dir)
        .. " && find " .. beez.char.quote(root .. "/" .. cfg.ebin_dir)
        .. " -name '*.beam' | head -1 | grep -q ."
end

function M.verify(cfg, root)
    
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

return M.verify_beams(cfg, root)
end

function M.test(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.gleam_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    return table.concat(parts, " ")
end

return M
