local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function pypy_binary(cfg)
    return "(command -v " .. cfg.pypy_binary .. " >/dev/null 2>&1 && echo " .. cfg.pypy_binary .. " || echo " .. cfg.pypy_fallback_binary .. ")"
end

function M.pip_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.pypy-setup"
    local pypy = pypy_binary(cfg)

    if not cfg.has_installable and not cfg.has_requirements then
        return table.concat({
            "PY=$( " .. pypy .. " )",
            "&&",
            "command -v \"$PY\"",
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    local parts = {
        "PY=$( " .. pypy .. " )",
        "&&",
        "command -v \"$PY\"",
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$PY\" -m pip",
    }

    if cfg.has_installable then
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "."
    else
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "-r"
        parts[#parts + 1] = beez.char.quote(cfg.requirements_path)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compileall(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir
    local pypy = pypy_binary(cfg)
    local parts = {
        "PY=$( " .. pypy .. " )",
        "&&",
        "command -v \"$PY\"",
        "&&",
        "mkdir -p " .. beez.char.quote(dest),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$PY\" -m compileall",
        "-b",
        "-d",
        beez.char.quote(dest),
        "-q",
        "-x",
        beez.char.quote(cfg.compile_exclude),
        ".",
    }

    return table.concat(parts, " ")
end

function M.verify_bytecode(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir
    return table.concat({
        "test -d " .. beez.char.quote(dest),
        "&&",
        "test -n \"$(find " .. beez.char.quote(dest) .. " -name '*.pyc' -print -quit 2>/dev/null)\"",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/pypy-" .. cfg.profile_name .. ".ok"
    local pypy = pypy_binary(cfg)
    local parts = {
        "PY=$( " .. pypy .. " )",
        "&&",
        "command -v \"$PY\"",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$PY\" -m",
        cfg.pytest_binary,
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end


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

return M
