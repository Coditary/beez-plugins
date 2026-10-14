local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.pip_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.cython-setup"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.pip_binary,
        "install",
        "cython",
        "setuptools",
        "wheel",
    }

    local req_file = cfg.project_root == "." and "requirements.txt" or cfg.project_root .. "/requirements.txt"
    local req_path = root .. "/" .. req_file

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "test -f " .. beez.char.quote(req_path)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = cfg.pip_binary
    parts[#parts + 1] = "install"
    parts[#parts + 1] = "-r"
    parts[#parts + 1] = beez.char.quote(req_file)
    parts[#parts + 1] = "||"
    parts[#parts + 1] = "true"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.build_ext(cfg, root)
    local lib = root .. "/" .. cfg.lib_dir
    local temp = root .. "/" .. cfg.temp_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(lib),
        "&&",
        "mkdir -p " .. beez.char.quote(temp),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_setup_py then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = "setup.py"
        parts[#parts + 1] = "build_ext"
        parts[#parts + 1] = "--build-lib"
        parts[#parts + 1] = beez.char.quote(lib)
        parts[#parts + 1] = "--build-temp"
        parts[#parts + 1] = beez.char.quote(temp)

        if cfg.build_ext_args ~= nil and cfg.build_ext_args ~= "" then
            parts[#parts + 1] = cfg.build_ext_args
        end
    elseif cfg.has_pyproject then
        parts[#parts + 1] = cfg.pip_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "."
    else
        local commands = {
            "mkdir -p " .. beez.char.quote(lib),
            "&&",
            project_cd(cfg, root),
        }
        for _, target in ipairs(cfg.targets) do
            local output_c = lib .. "/" .. target.name .. ".c"
            commands[#commands + 1] = "&&"
            commands[#commands + 1] = table.concat({
                cfg.cython_binary,
                cfg.cython_args,
                "-o",
                beez.char.quote(output_c),
                target.source,
            }, " ")
        end
        return table.concat(commands, " ")
    end

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    local lib = root .. "/" .. cfg.lib_dir
    local checks = {
        "test -d " .. beez.char.quote(lib),
        "&&",
        "test -n \"$(find " .. beez.char.quote(lib) .. " -type f \\( -name '*.so' -o -name '*.pyd' -o -name '*.c' \\) -print -quit 2>/dev/null)\"",
    }
    return table.concat(checks, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/cython-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_setup_py or cfg.has_pyproject then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = "-m"
        parts[#parts + 1] = "pytest"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "||"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

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
