local M = {}

local function workspace_cd(cfg, root)
    local ws = root
    if cfg.workspace_root ~= "." and cfg.workspace_root ~= "" then
        ws = root .. "/" .. cfg.workspace_root
    end

    return "cd " .. beez.char.quote(ws)
end

local function rustc_invocation(cfg)
    local parts = { cfg.rustc_binary }
    if cfg.rust_toolchain ~= nil and cfg.rust_toolchain ~= "" then
        parts[#parts + 1] = "+" .. cfg.rust_toolchain
    end
    return table.concat(parts, " ")
end

function M.fetch(cfg, root)
    local stamp = root .. "/" .. cfg.target_dir .. "/.rustc-gcc-fetched"

    local parts = {
        cfg.env_prefix,
        "&&",
        workspace_cd(cfg, root),
        "&&",
        cfg.cargo_binary,
        "fetch",
        "&&",
        "touch",
        beez.char.quote(stamp),
    }

    return table.concat(parts, " ")
end

function M.build(cfg, root)
    if cfg.use_rustc then
        
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

return M.build_with_rustc(cfg, root)
    end

    local parts = {
        cfg.env_prefix,
        "&&",
        workspace_cd(cfg, root),
        "&&",
        cfg.cargo_binary,
        "build",
    }

    if cfg.cargo_profile == "release" then
        parts[#parts + 1] = "--release"
    end

    if cfg.target_dir ~= nil and cfg.target_dir ~= "" then
        parts[#parts + 1] = "--target-dir"
        parts[#parts + 1] = beez.char.quote(cfg.target_dir)
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.build_with_rustc(cfg, root)
    local parts = {
        cfg.env_prefix,
        "&&",
        workspace_cd(cfg, root),
        "&&",
        rustc_invocation(cfg),
        "-C",
        "codegen-backend=" .. cfg.codegen_backend,
    }

    if cfg.cargo_profile == "release" then
        parts[#parts + 1] = "-C"
        parts[#parts + 1] = "opt-level=2"
    end

    parts[#parts + 1] = "--out-dir"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.bin_dir)
    parts[#parts + 1] = "--crate-type"
    parts[#parts + 1] = "bin"
    parts[#parts + 1] = "src/main.rs"

    return table.concat(parts, " ")
end

function M.verify_binaries(cfg, root)
    local checks = {}
    for _, name in ipairs(cfg.binary_names) do
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
        cfg.env_prefix,
        "&&",
        workspace_cd(cfg, root),
        "&&",
        "mkdir",
        "-p",
        beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.cargo_binary,
        "test",
    }

    if cfg.test_packages ~= nil and cfg.test_packages ~= "" then
        parts[#parts + 1] = "-p"
        parts[#parts + 1] = cfg.test_packages
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    return table.concat(parts, " ")
end

return M
