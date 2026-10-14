local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function compiler_flags_arg(cfg)
    if cfg.compiler_flags == nil or cfg.compiler_flags == "" then
        return ""
    end
    return cfg.compiler_flags
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.yhc-setup-done"
end

function M.setup(cfg, root)
    local stamp = setup_stamp(cfg, root)
    return table.concat({
        "command -v " .. beez.char.quote(cfg.compiler_binary),
        "&&",
        "(" .. cfg.compiler_binary .. " --version || " .. cfg.compiler_binary .. " -version || true)",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_target(cfg, root, target)
    local flags = compiler_flags_arg(cfg)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.compiler_binary,
    }

    if flags ~= "" then
        parts[#parts + 1] = flags
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. target.output)
    parts[#parts + 1] = beez.char.quote(target.source)

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_artifacts(cfg, root)
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
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/yhc-" .. cfg.profile_name .. ".ok"

    if cfg.test_sources == nil or #cfg.test_sources == 0 then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "echo 'yhc plugin: no test sources found — skipping tests'",
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    local flags = compiler_flags_arg(cfg)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    for _, test_source in ipairs(cfg.test_sources) do
        local test_output = cfg.build_dir .. "/test-" .. test_source:gsub("[^%w]", "_")
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.compiler_binary
        if flags ~= "" then
            parts[#parts + 1] = flags
        end
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. test_output)
        parts[#parts + 1] = beez.char.quote(test_source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. test_output)
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
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
