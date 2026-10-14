local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function nuitka_invocation(cfg)
    if cfg.use_module then
        return cfg.python_binary .. " -m " .. cfg.nuitka_binary
    end
    return cfg.nuitka_binary
end

local function nuitka_args(cfg)
    local parts = {}
    for _, arg in ipairs(cfg.nuitka_args) do
        parts[#parts + 1] = arg
    end

    if cfg.standalone then
        parts[#parts + 1] = "--standalone"
    end

    return table.concat(parts, " ")
end

function M.pip_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.nuitka-setup"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_pyproject then
        parts[#parts + 1] = cfg.pip_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "-e"
        parts[#parts + 1] = "."
        parts[#parts + 1] = "&&"
    elseif cfg.requirements_path ~= nil then
        parts[#parts + 1] = cfg.pip_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "-r"
        parts[#parts + 1] = beez.char.quote(cfg.requirements_path)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = cfg.pip_binary
    parts[#parts + 1] = "install"
    parts[#parts + 1] = "nuitka"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile_target(cfg, root, target)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        nuitka_invocation(cfg),
    }

    local args = nuitka_args(cfg)
    if args ~= "" then
        parts[#parts + 1] = args
    end

    parts[#parts + 1] = "--output-dir=" .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    parts[#parts + 1] = target.source

    return table.concat(parts, " ")
end

function M.compile_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_binaries(cfg, root)
    local target_checks = {}
    for _, target in ipairs(cfg.targets) do
        target_checks[#target_checks + 1] = table.concat({
            "test -f " .. beez.char.quote(root .. "/" .. target.output),
            "||",
            "test -x " .. beez.char.quote(root .. "/" .. target.output .. ".bin"),
            "||",
            "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir .. "/" .. target.name .. ".dist"),
        }, " ")
    end

    if #target_checks == 0 then
        return "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(target_checks, " && ")
end

function M.test(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.python_binary,
        "-m",
        "pytest",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/nuitka-" .. cfg.profile_name .. ".ok")

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
