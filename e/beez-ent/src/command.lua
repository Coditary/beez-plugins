local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_go(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ent-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.go_binary,
        "version",
        "&&",
    }

    if cfg.has_schema_files then
        parts[#parts + 1] = "test -d " .. beez.char.quote(cfg.ent_schema_dir)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.ent_binary,
        "generate",
        beez.char.quote(cfg.ent_schema_dir),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.verify_output(cfg, root)
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -d " .. beez.char.quote(cfg.ent_output_dir),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/ent-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.go_binary,
        "build",
        beez.char.quote("./" .. cfg.ent_output_dir .. "/..."),
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
