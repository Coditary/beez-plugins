local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_bitbake(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.yocto-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.bitbake_binary,
        "--version",
        "&&",
    }

    if cfg.has_local_conf and cfg.local_conf ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.local_conf)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.bitbake_binary,
        "-p",
    }

    if cfg.bb_target ~= nil and cfg.bb_target ~= "" then
        parts[#parts + 1] = beez.char.quote(cfg.bb_target)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/yocto-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_recipes then
        parts[#parts + 1] = cfg.bitbake_binary
        parts[#parts + 1] = "-p"
        if cfg.bb_target ~= nil and cfg.bb_target ~= "" then
            parts[#parts + 1] = beez.char.quote(cfg.bb_target)
        end
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
