local M = {}

local function package_cd(cfg, root)
    local pkg_root = root
    if cfg.package_root ~= "." and cfg.package_root ~= "" then
        pkg_root = root .. "/" .. cfg.package_root
    end

    return "cd " .. beez.char.quote(pkg_root)
end

function M.resolve(cfg, root)
    local stamp = root .. "/" .. cfg.build_path .. "/.swift-resolved"

    local parts = {
        package_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_path),
        "&&",
        cfg.swift_binary,
        "package resolve",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }

    return table.concat(parts, " ")
end

function M.build(cfg, root)
    local parts = {
        package_cd(cfg, root),
        "&&",
        cfg.swift_binary,
        "build",
        "--build-path",
        beez.char.quote(cfg.build_path),
        "-c",
        cfg.configuration,
    }

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.verify_binaries(cfg, root)
    local checks = {}
    for _, name in ipairs(cfg.executable_names) do
        local path = root .. "/" .. cfg.bin_dir .. "/" .. name
        checks[#checks + 1] = "test -f " .. beez.char.quote(path)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local parts = {
        package_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.swift_binary,
        "test",
        "--build-path",
        beez.char.quote(cfg.build_path),
        "-c",
        cfg.configuration,
    }

    if cfg.test_filter ~= nil and cfg.test_filter ~= "" then
        parts[#parts + 1] = "--filter"
        parts[#parts + 1] = beez.char.quote(cfg.test_filter)
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
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
