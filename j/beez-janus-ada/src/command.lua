local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function compile_flags(cfg)
    local flags = {}
    if cfg.optimize ~= nil and cfg.optimize ~= "" then
        flags[#flags + 1] = cfg.optimize
    end
    if cfg.debug_info ~= nil and cfg.debug_info ~= "" then
        flags[#flags + 1] = cfg.debug_info
    end
    return table.concat(flags, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.janus-setup-ok"
    return table.concat({
        "command -v " .. cfg.compiler_binary .. " >/dev/null 2>&1 || command -v " .. cfg.ada_binary .. " >/dev/null 2>&1",
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

function M.build_target(cfg, root, target)
    local flags = compile_flags(cfg)
    local output_path = root .. "/" .. target.output
    local obj_dir = root .. "/" .. cfg.obj_dir
    local source_name = target.source:match("([^/]+)$") or target.source
    local base_name = source_name:match("^(.+)%.[^%.]+$") or source_name

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(obj_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.compiler_binary,
    }

    if flags ~= "" then
        parts[#parts + 1] = flags
    end

    parts[#parts + 1] = target.source
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "if test -f " .. beez.char.quote(base_name .. ".exe") .. "; then cp "
        .. beez.char.quote(base_name .. ".exe") .. " " .. beez.char.quote(output_path)
        .. "; elif test -f " .. beez.char.quote(base_name) .. "; then cp "
        .. beez.char.quote(base_name) .. " " .. beez.char.quote(output_path)
        .. "; elif test -f " .. beez.char.quote(obj_dir .. "/" .. base_name .. ".exe") .. "; then cp "
        .. beez.char.quote(obj_dir .. "/" .. base_name .. ".exe") .. " " .. beez.char.quote(output_path)
        .. "; else test -f " .. beez.char.quote(output_path) .. "; fi"

    return table.concat(parts, " ")
end

function M.build_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify(cfg, root)
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
    local report = root .. "/" .. cfg.reports_dir .. "/test/janus-" .. cfg.profile_name .. ".ok"

    if #cfg.test_targets == 0 then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(report),
        }, " ")
    end

    local commands = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    for _, target in ipairs(cfg.test_targets) do
        commands[#commands + 1] = "&&"
        commands[#commands + 1] = M.build_target(cfg, root, target)
        commands[#commands + 1] = "&&"
        commands[#commands + 1] = beez.char.quote(root .. "/" .. target.output)
    end

    commands[#commands + 1] = "&&"
    commands[#commands + 1] = "touch " .. beez.char.quote(report)

    return table.concat(commands, " ")
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
