local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

local function compiler_resolve_cmd(cfg)
    return table.concat({
        "COMP=$(",
        "command -v ",
        beez.char.quote(cfg.ifx_binary),
        " >/dev/null 2>&1 && echo ",
        beez.char.quote(cfg.ifx_binary),
        " || (command -v ",
        beez.char.quote(cfg.ifort_binary),
        " >/dev/null 2>&1 && echo ",
        beez.char.quote(cfg.ifort_binary),
        " || (echo 'ifx/ifort not found' >&2; exit 127))",
        ")",
    }, "")
end

local function compile_flags(cfg)
    local parts = { cfg.optimize }

    if cfg.debug_flags ~= nil and cfg.debug_flags ~= "" then
        parts[#parts + 1] = cfg.debug_flags
    end

    for _, flag in ipairs(cfg.extra_flags) do
        parts[#parts + 1] = flag
    end

    return table.concat(parts, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ifx-setup-done"
    return table.concat({
        compiler_resolve_cmd(cfg),
        "&&",
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch",
        beez.char.quote(stamp),
    }, " ")
end

function M.compile_direct(cfg, root, target)
    local sources = target.sources or cfg.sources
    local quoted_sources = {}
    for _, source in ipairs(sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(source)
    end

    return table.concat({
        compiler_resolve_cmd(cfg),
        "&&",
        "cd",
        beez.char.quote(project_dir(cfg, root)),
        "&&",
        "$COMP",
        compile_flags(cfg),
        "-o",
        beez.char.quote(root .. "/" .. target.output),
        table.concat(quoted_sources, " "),
    }, " ")
end

function M.compile_makefile(cfg, root)
    local flags = compile_flags(cfg)
    return table.concat({
        compiler_resolve_cmd(cfg),
        "&&",
        "cd",
        beez.char.quote(project_dir(cfg, root)),
        "&&",
        "make",
        "FC=$COMP",
        "FFLAGS=" .. beez.char.quote(flags),
        "LDFLAGS=" .. beez.char.quote(flags),
    }, " ")
end

function M.compile_all(cfg, root)
    if cfg.build_system == "makefile" then
        
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

return M.compile_makefile(cfg, root)
    end

    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_direct(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/ifx-" .. cfg.profile_name .. ".ok"

    if cfg.build_system == "makefile" then
        return table.concat({
            "cd",
            beez.char.quote(project_dir(cfg, root)),
            "&&",
            "mkdir -p",
            beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "make test",
            "&&",
            "touch",
            beez.char.quote(ok_file),
        }, " ")
    end

    local primary = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "test -x",
        beez.char.quote(primary),
        "&&",
        beez.char.quote(primary),
        cfg.test_args,
        "&&",
        "touch",
        beez.char.quote(ok_file),
    }, " ")
end

return M
