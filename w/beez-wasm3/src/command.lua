local M = {}

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.wasm3-setup"
    return table.concat({
        "command -v " .. cfg.wasm3_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.syntax_check_target(cfg, root, target)
    return table.concat({
        "command -v " .. cfg.wasm3_binary,
        "&&",
        "test -f " .. beez.char.quote(target.source),
    }, " ")
end

function M.syntax_check_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.syntax_check_target(cfg, root, target)
    end
    local stamp = root .. "/" .. cfg.compile_stamp
    commands[#commands + 1] = table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
    return table.concat(commands, " && ")
end

function M.verify_compile_stamp(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.compile_stamp)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/wasm3-" .. cfg.profile_name .. ".ok"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        M.run(cfg, root),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.run(cfg, root)
    local run_args = beez.env_or("BEEZ_RUN_ARGS", cfg.run_args or "")
    if cfg.run_command ~= nil and cfg.run_command ~= "" then
        if run_args ~= "" then return cfg.run_command .. " " .. run_args end
        return cfg.run_command
    end
    if cfg.primary_output ~= nil then
        local wasm = cfg.primary_output
        local parts = { cfg.wasm3_binary }
        if cfg.run_prefix ~= nil and cfg.run_prefix ~= "" then
            parts[#parts + 1] = cfg.run_prefix
        end
        parts[#parts + 1] = beez.char.quote(wasm)
        if run_args ~= "" then parts[#parts + 1] = run_args end
        return table.concat(parts, " ")
    end
    error("run: no wasm target configured")
end

return M
