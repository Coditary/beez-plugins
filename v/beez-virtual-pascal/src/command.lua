local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function exe_dir_for_target(cfg, root, target)
    local output_path = root .. "/" .. target.output
    local dir = output_path:match("^(.*)/[^/]+$") or (root .. "/" .. cfg.bin_dir)
    return dir
end

local function vpo_arg(cfg)
    if cfg.vpo_file == nil or cfg.vpo_file == "" then
        return ""
    end
    return "-V" .. cfg.vpo_file
end

function M.prepare(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.virtual-pascal-prepared"

    return table.concat({
        "(",
        "command -v " .. cfg.vpc_binary .. " >/dev/null 2>&1",
        "||",
        "command -v vpcc >/dev/null 2>&1",
        "||",
        cfg.vpc_binary,
        "2>/dev/null",
        "||",
        "vpcc 2>/dev/null",
        "||",
        "true",
        ")",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_target(cfg, root, target)
    local exe_dir = exe_dir_for_target(cfg, root, target)
    local parts = {
        "mkdir -p " .. beez.char.quote(exe_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.vpc_binary,
    }

    local vpo = vpo_arg(cfg)
    if vpo ~= "" then
        parts[#parts + 1] = vpo
    end

    if cfg.vpc_args ~= nil and cfg.vpc_args ~= "" then
        parts[#parts + 1] = cfg.vpc_args
    end

    parts[#parts + 1] = "-E" .. beez.char.quote(exe_dir)
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
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/virtual-pascal-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
    }

    if cfg.test_runner ~= nil then
        local runner_dir = cfg.test_runner:match("^(.*)/[^/]+$") or "."
        local runner_name = cfg.test_runner:match("([^/]+)$") or "testrunner"
        local runner_stem = runner_name:match("^(.+)%.[^%.]+$") or runner_name
        local runner_output = root .. "/" .. cfg.bin_dir .. "/" .. runner_stem .. ".exe"

        parts[#parts + 1] = project_cd(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.vpc_binary

        local vpo = vpo_arg(cfg)
        if vpo ~= "" then
            parts[#parts + 1] = vpo
        end

        parts[#parts + 1] = "-B"
        parts[#parts + 1] = "-E" .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        if runner_dir ~= "." then
            parts[#parts + 1] = "-U" .. beez.char.quote(runner_dir)
        end
        parts[#parts + 1] = cfg.test_runner
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "test -f " .. beez.char.quote(runner_output)
    else
        parts[#parts + 1] = "("
        parts[#parts + 1] = cfg.vpc_binary
        parts[#parts + 1] = "2>/dev/null"
        parts[#parts + 1] = "||"
        parts[#parts + 1] = "vpcc 2>/dev/null"
        parts[#parts + 1] = "||"
        parts[#parts + 1] = "true"
        parts[#parts + 1] = ")"
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
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
