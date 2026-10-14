local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.fetch(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ldc-fetched"

    if not cfg.use_dub then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        cfg.dub_binary,
        "fetch",
        "--compiler=" .. cfg.ldc_binary,
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_target(cfg, root, target)
    local output = root .. "/" .. target.output

    if cfg.use_dub then
        local parts = {
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
            "&&",
            cfg.dub_binary,
            "build",
            "--compiler=" .. cfg.ldc_binary,
            "--build=" .. cfg.dub_build,
        }

        if cfg.dub_dflags ~= nil and cfg.dub_dflags ~= "" then
            parts[#parts + 1] = "--dflags=" .. beez.char.quote(cfg.dub_dflags)
        end

        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "bin_path=$(" .. cfg.dub_binary .. " describe --data=targetBinaryPath 2>/dev/null || echo " .. beez.char.quote(cfg.target_name) .. ")"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "cp " .. beez.char.quote("$bin_path") .. " " .. beez.char.quote(output)

        return table.concat(parts, " ")
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.ldc_binary,
        cfg.ldc_flags,
        "-of=" .. beez.char.quote(output),
        beez.char.quote(root .. "/" .. target.entry),
    }, " ")
end

function M.build_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_binaries(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/ldc-" .. cfg.profile_name .. ".ok"

    if not cfg.use_dub then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "echo 'ldc plugin: no dub manifest — skipping dub test'",
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.dub_binary,
        "test",
        "--compiler=" .. cfg.ldc_binary,
        "--build=" .. cfg.dub_build,
    }

    if cfg.dub_dflags ~= nil and cfg.dub_dflags ~= "" then
        parts[#parts + 1] = "--dflags=" .. beez.char.quote(cfg.dub_dflags)
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

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
