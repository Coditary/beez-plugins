local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_eww(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.yuck-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.eww_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local config_dir = cfg.config_dir or cfg.project_root or "."
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.eww_binary,
        "daemon",
        "--config",
        beez.char.quote(config_dir),
        "--no-daemonize",
        "&",
        "eww_pid=$!",
        "&&",
        "sleep 2",
        "&&",
        cfg.eww_binary,
        "ping",
        "&&",
        cfg.eww_binary,
        "kill",
        "&&",
        "wait $eww_pid 2>/dev/null || true",
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/yuck-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
