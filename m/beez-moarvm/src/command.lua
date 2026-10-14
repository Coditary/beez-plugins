local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_binaries(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.moarvm-setup"

    return table.concat({
        "command -v " .. cfg.moar_binary,
        "&&",
        "command -v " .. cfg.nqp_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_sources(cfg, root)
    local stamp = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "command -v " .. cfg.nqp_binary,
        "&&",
        "command -v " .. cfg.moar_binary,
    }

    for _, source in ipairs(cfg.nqp_sources) do
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.nqp_binary
        parts[#parts + 1] = "-c"
        parts[#parts + 1] = beez.char.quote(source)
    end

    for _, moar_file in ipairs(cfg.moar_files) do
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.moar_binary
        parts[#parts + 1] = "--version"
        parts[#parts + 1] = ">/dev/null"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "test -f " .. beez.char.quote(moar_file)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.verify_compile(cfg, root)
    local stamp = root .. "/" .. cfg.primary_output
    return table.concat({
        "test -f " .. beez.char.quote(stamp),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/moarvm-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
    }

    if #cfg.test_files > 0 then
        parts[#parts + 1] = "&&"
        for i, test_file in ipairs(cfg.test_files) do
            if i > 1 then
                parts[#parts + 1] = "&&"
            end
            if test_file:match("%.nqp$") then
                parts[#parts + 1] = cfg.nqp_binary
            else
                parts[#parts + 1] = cfg.moar_binary
            end
            parts[#parts + 1] = beez.char.quote(test_file)
        end
    else
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "echo \"[moarvm-test] no tests in t/ — skipping\""
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
