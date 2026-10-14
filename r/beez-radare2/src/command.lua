local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_r2(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.radare2-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.r2_binary,
        "-v",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local report_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.report_name
    local target = cfg.entry_source
    if target == nil then
        error("radare2 compile: no binary target detected")
    end

    local r2_cmd = "aaa; afl; iI; q"
    if cfg.profile_name == "debug" then
        r2_cmd = "aaa; afl; pdf @ entry0; iI; q"
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.r2_binary,
        "-A",
        "-q",
        "-c",
        beez.char.quote(r2_cmd),
        beez.char.quote(target),
        ">",
        beez.char.quote(report_file),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local report_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.report_name
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -s " .. beez.char.quote(report_file),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/radare2-" .. cfg.profile_name .. ".ok"
    local report_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.report_name
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -s " .. beez.char.quote(report_file),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end



return M
