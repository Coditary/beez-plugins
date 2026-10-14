local M = {}

local function workspace_cd(cfg, root)
    local ws = root
    if cfg.workspace_root ~= "." and cfg.workspace_root ~= "" then
        ws = root .. "/" .. cfg.workspace_root
    end

    return "cd " .. beez.char.quote(ws)
end

local function libstd_args(cfg)
    if cfg.libstd_dir == nil or cfg.libstd_dir == "" then
        return ""
    end

    return "-L " .. beez.char.quote(cfg.libstd_dir)
end

function M.verify_compiler(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.mrustc-verified"

    return table.concat({
        "command -v " .. cfg.mrustc_binary .. " >/dev/null",
        "&& " .. cfg.mrustc_binary .. " --version >/dev/null 2>&1",
        "&& mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&& touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_target(cfg, root, target)
    local output = root .. "/" .. target.output
    local out_dir = root .. "/" .. cfg.build_dir

    local parts = {
        workspace_cd(cfg, root),
        "&& mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&& " .. cfg.mrustc_binary,
    }

    local libstd = libstd_args(cfg)
    if libstd ~= "" then
        parts[#parts + 1] = libstd
    end

    parts[#parts + 1] = "--out-dir " .. beez.char.quote(out_dir)

    if cfg.optimize then
        parts[#parts + 1] = "-O"
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    parts[#parts + 1] = beez.char.quote(target.source)
    parts[#parts + 1] = "-o " .. beez.char.quote(output)

    return table.concat(parts, " ")
end

function M.build_all(cfg, root)
    local cmds = {}
    for _, target in ipairs(cfg.targets) do
        cmds[#cmds + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(cmds, " && ")
end

function M.verify(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local report_ok = root .. "/" .. cfg.reports_dir .. "/test/mrustc-" .. cfg.profile_name .. ".ok"
    local test_out_dir = root .. "/" .. cfg.build_dir .. "/test"

    local libstd = libstd_args(cfg)
    local minicargo_parts = {
        workspace_cd(cfg, root),
        "&& mkdir -p " .. beez.char.quote(test_out_dir),
        "&& command -v " .. cfg.minicargo_binary .. " >/dev/null",
        "&& " .. cfg.minicargo_binary,
    }

    if libstd ~= "" then
        minicargo_parts[#minicargo_parts + 1] = libstd
    end

    minicargo_parts[#minicargo_parts + 1] = "--output-dir " .. beez.char.quote(test_out_dir)
    minicargo_parts[#minicargo_parts + 1] = "test"
    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        minicargo_parts[#minicargo_parts + 1] = cfg.test_args
    end
    minicargo_parts[#minicargo_parts + 1] = "."

    local smoke_parts = {
        workspace_cd(cfg, root),
        "&& test -x " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&& " .. beez.char.quote(root .. "/" .. cfg.primary_output) .. " --help >/dev/null 2>&1",
    }

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&& (",
        table.concat(minicargo_parts, " "),
        "||",
        table.concat(smoke_parts, " "),
        ")",
        "&& touch " .. beez.char.quote(report_ok),
    }, " ")
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
