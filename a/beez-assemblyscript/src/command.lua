local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.npm_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.assemblyscript-setup"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "install",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local wasm_dir = root .. "/" .. cfg.wasm_dir
    local out_file = wasm_dir .. "/" .. cfg.output_name .. ".wasm"
    local parts = {
        "mkdir -p " .. beez.char.quote(wasm_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.asc_binary,
    }

    if cfg.has_asconfig then
        parts[#parts + 1] = "--config"
        parts[#parts + 1] = beez.char.quote(cfg.asconfig_path)
        parts[#parts + 1] = "--target"
        parts[#parts + 1] = cfg.asc_target
    end

    if not cfg.has_asconfig then
        for _, target in ipairs(cfg.targets) do
            parts[#parts + 1] = beez.char.quote(target.source)
        end
    end

    parts[#parts + 1] = "--outFile"
    parts[#parts + 1] = beez.char.quote(out_file)

    if cfg.asc_args ~= nil and cfg.asc_args ~= "" then
        parts[#parts + 1] = cfg.asc_args
    end

    return table.concat(parts, " ")
end

function M.verify_wasm(cfg, root)
    local wasm_dir = root .. "/" .. cfg.wasm_dir
    local out_file = wasm_dir .. "/" .. cfg.output_name .. ".wasm"
    return "test -f " .. beez.char.quote(out_file)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/assemblyscript-" .. cfg.profile_name .. ".ok"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(ok_file),
        }, " ")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = "--"
        parts[#parts + 1] = cfg.test_args
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
