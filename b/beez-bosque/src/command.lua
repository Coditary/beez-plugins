local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

function M.verify_toolchain(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.bosque-setup"
    local parts = {
        "command -v " .. cfg.node_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
    }

    if cfg.has_manifest then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = project_cd(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.npm_binary
        parts[#parts + 1] = "install"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)
    return table.concat(parts, " ")
end

function M.compile_exe(cfg, root, target)
    local output = root .. "/" .. target.output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_manifest then
        parts[#parts + 1] = cfg.bosque_binary
        parts[#parts + 1] = "build"
        if cfg.manifest_path ~= nil then
            parts[#parts + 1] = beez.char.quote(cfg.manifest_path)
        end
    else
        parts[#parts + 1] = cfg.node_binary
        parts[#parts + 1] = beez.char.quote(cfg.exegen_script)
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(output)
        parts[#parts + 1] = target.source
    end

    return table.concat(parts, " ")
end

function M.compile_interpret(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_manifest then
        parts[#parts + 1] = cfg.bosque_binary
        parts[#parts + 1] = "test"
        if cfg.manifest_path ~= nil then
            parts[#parts + 1] = beez.char.quote(cfg.manifest_path)
        end
    else
        parts[#parts + 1] = cfg.node_binary
        parts[#parts + 1] = beez.char.quote(cfg.exegen_script)
        parts[#parts + 1] = "-c"
        parts[#parts + 1] = cfg.targets[1].source
    end

    return table.concat(parts, " ")
end

function M.compile_all(cfg, root)
    if cfg.compile_mode == "interpret" then
        
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

return M.compile_interpret(cfg, root)
    end

    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_exe(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_artifacts(cfg, root)
    if cfg.compile_mode == "interpret" then
        return "test -d " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    end

    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/bosque-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_manifest then
        parts[#parts + 1] = cfg.bosque_binary
        parts[#parts + 1] = "test"
        if cfg.manifest_path ~= nil then
            parts[#parts + 1] = beez.char.quote(cfg.manifest_path)
        end
    else
        parts[#parts + 1] = "true"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    return table.concat(parts, " ")
end

return M
