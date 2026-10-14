local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function wine_env(cfg)
    if cfg.wine_prefix ~= nil and cfg.wine_prefix ~= "" then
        return "WINEPREFIX=" .. beez.char.quote(cfg.wine_prefix) .. " WINEDEBUG=-all "
    end
    return "WINEDEBUG=-all "
end

function M.wine_run(cfg, win_exe, ...)
    local parts = {
        wine_env(cfg) .. cfg.wine_binary,
        beez.char.quote(win_exe),
    }

    for i = 1, select("#", ...) do
        parts[#parts + 1] = select(i, ...)
    end

    return table.concat(parts, " ")
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.jscript-setup"
    return table.concat({
        "command -v " .. cfg.wine_binary,
        "&&",
        project_cd(cfg, root),
        "&&",
        M.wine_run(cfg, cfg.cscript_binary, "//Nologo", "//E:jscript", "//?"),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.syntax_check_target(cfg, root, target)
    local parts = {
        project_cd(cfg, root),
        "&&",
        M.wine_run(cfg, cfg.cscript_binary),
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        for token in cfg.compile_args:gmatch("%S+") do
            parts[#parts + 1] = token
        end
    end

    parts[#parts + 1] = beez.char.quote(target.source)

    return table.concat(parts, " ")
end

function M.syntax_check_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.syntax_check_target(cfg, root, target)
    end

    local stamp = root .. "/" .. cfg.compile_stamp
    commands[#commands + 1] = table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")

    return table.concat(commands, " && ")
end

function M.verify_compile_stamp(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.compile_stamp)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/jscript-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        parts[#parts + 1] = M.wine_run(
            cfg,
            cfg.cscript_binary,
            "//Nologo",
            "//E:jscript",
            "//B",
            beez.char.quote(cfg.entry_source)
        )
        parts[#parts + 1] = "&&"
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
