local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.iverilog-setup"
    return table.concat({
        "command -v " .. cfg.iverilog_binary,
        "&&",
        "command -v " .. cfg.vvp_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.syntax_check_target(cfg, root, target)
    return table.concat({ project_cd(cfg, root), "&&", "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir), "&&", cfg.iverilog_binary, "-o", beez.char.quote(root .. "/" .. cfg.primary_output), target.source }, " ")
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
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/iverilog-" .. cfg.profile_name .. ".ok"
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
    local vvp_file = root .. "/" .. cfg.primary_output
    local parts = { cfg.vvp_binary, beez.char.quote(vvp_file) }
    if run_args ~= "" then parts[#parts + 1] = run_args end
    return table.concat(parts, " ")
end

return M
