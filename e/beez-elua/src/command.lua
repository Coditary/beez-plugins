local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.elua-setup"

    return table.concat({
        "command -v " .. cfg.scons_binary,
        "&&",
        "command -v " .. cfg.cross_gcc_binary,
        "&&",
        "command -v " .. cfg.lua_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local build_out = cfg.elua_build_subdir .. "/" .. cfg.platform
    local dest = root .. "/" .. cfg.bin_dir

    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.scons_binary,
        "target=" .. cfg.platform,
        "-Q",
    }

    if cfg.scons_extra_args ~= nil and cfg.scons_extra_args ~= "" then
        parts[#parts + 1] = cfg.scons_extra_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(dest)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "test -d " .. beez.char.quote(build_out)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "cp -a " .. beez.char.quote(build_out .. "/.") .. " " .. beez.char.quote(dest .. "/")

    return table.concat(parts, " ")
end

function M.verify_firmware(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir

    return table.concat({
        "test -d " .. beez.char.quote(dest),
        "&&",
        "test -n \"$(find "
            .. beez.char.quote(dest)
            .. " -maxdepth 2 -type f \\( -name '*.elf' -o -name '*.bin' -o -name 'elua' -o -name 'elua.exe' \\) -print -quit)\"",
    }, " ")
end

function M.test_scripts(cfg, root)
    if cfg.app_scripts == nil or #cfg.app_scripts == 0 then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            project_cd(cfg, root),
            "&&",
            cfg.scons_binary,
            "target=linux",
            "-Q",
            "&&",
            "test -x " .. beez.char.quote(cfg.elua_build_subdir .. "/linux/elua")
                .. " || test -f " .. beez.char.quote(cfg.elua_build_subdir .. "/linux/elua"),
        }, " ")
    end

    local checks = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    for _, script in ipairs(cfg.app_scripts) do
        checks[#checks + 1] = "&&"
        checks[#checks + 1] = project_cd(cfg, root)
        checks[#checks + 1] = "&&"
        checks[#checks + 1] = cfg.lua_binary
        checks[#checks + 1] = "-e"
        checks[#checks + 1] = beez.char.quote("assert(loadfile(" .. string.format("%q", script) .. "))")
    end

    return table.concat(checks, " ")
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
