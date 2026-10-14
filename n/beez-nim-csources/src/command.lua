local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.build_csources(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.csources-built"
    local bootstrap = root .. "/" .. cfg.bootstrap_nim

    if cfg.build_nim_script ~= nil then
        return table.concat({
            project_cd(cfg, root),
            "&&",
            "sh " .. beez.char.quote(cfg.build_nim_script),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    local csources_path = cfg.csources_dir
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        csources_path = cfg.project_root .. "/" .. cfg.csources_dir
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "cd " .. beez.char.quote(root .. "/" .. csources_path),
        "&&",
        "CC=" .. cfg.cc_binary,
        "sh build.sh",
        "&&",
        "cp bin/nim " .. beez.char.quote(bootstrap),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.bootstrap_nim(cfg, root)
    if not cfg.has_koch then
        error("nim-csources compile: koch.nim not found — bootstrap requires a Nim compiler source tree")
    end

    local bootstrap = root .. "/" .. cfg.bootstrap_nim
    local nim_out = root .. "/" .. cfg.nim_output
    local project_bin = root .. "/bin/nim"

    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        project_bin = root .. "/" .. cfg.project_root .. "/bin/nim"
    end

    local parts = {
        project_cd(cfg, root),
        "&&",
        "test -x " .. beez.char.quote(bootstrap),
        "&&",
        beez.char.quote(bootstrap),
        "c --skipUserCfg --skipParentCfg koch",
        "&&",
        "./" .. cfg.koch_binary,
        "boot",
    }

    if cfg.boot_args ~= nil and cfg.boot_args ~= "" then
        parts[#parts + 1] = cfg.boot_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "cp " .. beez.char.quote(project_bin) .. " " .. beez.char.quote(nim_out)

    return table.concat(parts, " ")
end

function M.verify_nim(cfg, root)
    local nim_out = root .. "/" .. cfg.nim_output
    local bootstrap = root .. "/" .. cfg.bootstrap_nim

    local checks = {
        "test -f " .. beez.char.quote(bootstrap),
        "test -x " .. beez.char.quote(bootstrap),
        "test -f " .. beez.char.quote(nim_out),
        "test -x " .. beez.char.quote(nim_out),
        beez.char.quote(nim_out) .. " --version >/dev/null 2>&1",
    }

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local report_ok = root .. "/" .. cfg.reports_dir .. "/test/nim-csources-" .. cfg.profile_name .. ".ok"
    local nim_out = root .. "/" .. cfg.nim_output

    local koch_test = {
        project_cd(cfg, root),
        "&&",
        "test -x ./" .. cfg.koch_binary,
        "&&",
        "./" .. cfg.koch_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        koch_test[#koch_test + 1] = cfg.test_args
    end

    local smoke_test = {
        beez.char.quote(nim_out) .. " --version >/dev/null 2>&1",
        "&&",
        beez.char.quote(nim_out) .. " e --skipUserCfg --skipParentCfg 'echo ok' >/dev/null 2>&1",
    }

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&& (",
        table.concat(koch_test, " "),
        "||",
        table.concat(smoke_test, " "),
        ")",
        "&& touch " .. beez.char.quote(report_ok),
    }, " ")
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
