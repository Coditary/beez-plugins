local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.duckdb-setup"
    return table.concat({
        "command -v " .. cfg.duckdb_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.syntax_check_target(cfg, root, target)
    return table.concat({ project_cd(cfg, root), "&&", cfg.duckdb_binary .. ' -c ".read \'' .. target.source .. '\""' }, " ")
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
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/duckdb-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.duckdb_binary,
    }
    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end
    parts[#parts + 1] = beez.char.quote(cfg.primary_source)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    return table.concat(parts, " ")
end

function M.run(cfg, root)
    local run_args = beez.env_or("BEEZ_RUN_ARGS", cfg.run_args or "")
    local parts = {}
    if cfg.project_root ~= nil and cfg.project_root ~= "." and cfg.project_root ~= "" then
        parts[#parts + 1] = "cd " .. beez.char.quote(root .. "/" .. cfg.project_root)
        parts[#parts + 1] = "&&"
    end
    parts[#parts + 1] = cfg.duckdb_binary
    parts[#parts + 1] = "-c"
    parts[#parts + 1] = "\".read '" .. cfg.primary_source .. "'\""
    if run_args ~= "" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.duckdb_binary
        parts[#parts + 1] = "-c"
        parts[#parts + 1] = run_args
    end
    return table.concat(parts, " ")
end

return M
