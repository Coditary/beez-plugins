local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.solidity-setup"
    local parts = {
        "(command -v " .. cfg.forge_binary .. " >/dev/null 2>&1 && " .. cfg.forge_binary .. " --version",
        "|| " .. cfg.solc_binary .. " --version)",
    }

    if cfg.has_foundry_toml then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "(command -v " .. cfg.forge_binary .. " >/dev/null 2>&1 && " .. cfg.forge_binary .. " install || true)"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile_target(cfg, root, target)
    local out_dir = root .. "/" .. cfg.bin_dir
    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(out_dir),
        "&&",
        cfg.solc_binary,
        "--bin",
        "-o",
        beez.char.quote(out_dir),
        target.source,
    }, " ")
end

function M.compile(cfg, root)
    local parts = {}

    if cfg.has_foundry_toml then
        parts[#parts + 1] = table.concat({
            project_cd(cfg, root),
            "&&",
            cfg.forge_binary,
            "build",
        }, " ")
    else
        for _, target in ipairs(cfg.targets) do
            parts[#parts + 1] = M.compile_target(cfg, root, target)
        end
    end

    local stamp = root .. "/" .. cfg.compile_stamp
    parts[#parts + 1] = table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")

    return table.concat(parts, " && ")
end

function M.verify_compile_stamp(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.compile_stamp)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/solidity-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_foundry_toml then
        parts[#parts + 1] = cfg.forge_binary
        parts[#parts + 1] = "test"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
    else
        parts[#parts + 1] = "true"
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
