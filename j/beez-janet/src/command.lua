local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.install_deps(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.janet-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.janet_binary,
        "--version",
        "&&",
        cfg.jpm_binary,
        "help",
    }

    if cfg.has_project_janet then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.jpm_binary
        parts[#parts + 1] = "-l"
        parts[#parts + 1] = "deps"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.static_compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_project_janet then
        parts[#parts + 1] = cfg.jpm_binary
        parts[#parts + 1] = "-l"
        parts[#parts + 1] = "--buildpath=" .. cfg.build_dir
        parts[#parts + 1] = "build"
        parts[#parts + 1] = "&&"
        if cfg.entry_source ~= nil then
            parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.build_dir .. "/" .. cfg.output_name)
            parts[#parts + 1] = "&&"
            parts[#parts + 1] = "cp"
            parts[#parts + 1] = beez.char.quote(cfg.build_dir .. "/" .. cfg.output_name)
            parts[#parts + 1] = beez.char.quote(output)
        else
            local built = cfg.build_dir .. "/*"
            parts[#parts + 1] = "test -n \"$(find " .. beez.char.quote(cfg.build_dir) .. " -maxdepth 1 -type f -perm -111 -print -quit 2>/dev/null)\""
            parts[#parts + 1] = "&&"
            parts[#parts + 1] = "cp"
            parts[#parts + 1] = "$(find " .. beez.char.quote(cfg.build_dir) .. " -maxdepth 1 -type f -perm -111 | head -1)"
            parts[#parts + 1] = beez.char.quote(output)
        end
    else
        parts[#parts + 1] = cfg.jpm_binary
        parts[#parts + 1] = "quickbin"
        parts[#parts + 1] = cfg.entry_source
        parts[#parts + 1] = beez.char.quote(output)
    end

    return table.concat(parts, " ")
end

function M.verify_binary(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
        .. " && test -x " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/janet-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.has_project_janet then
        parts[#parts + 1] = cfg.jpm_binary
        parts[#parts + 1] = "-l"
        if cfg.test_args == "--verbose" then
            parts[#parts + 1] = "--verbose"
        end
        parts[#parts + 1] = "test"
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
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
