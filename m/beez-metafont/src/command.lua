local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.metafont-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        "(",
        cfg.mf_binary,
        "-version",
        "||",
        cfg.mf_fallback_binary,
        "-version",
        ")",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local bin_dir = root .. "/" .. cfg.bin_dir
    local input_cmd = "\\mode:=" .. cfg.mode .. "; input " .. cfg.jobname
    return table.concat({
        "mkdir -p " .. beez.char.quote(bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "(",
        cfg.mf_binary,
        "-interaction=nonstopmode",
        beez.char.quote(input_cmd),
        "||",
        cfg.mf_fallback_binary,
        "-interaction=nonstopmode",
        beez.char.quote(input_cmd),
        ")",
        "&&",
        "mv -f " .. cfg.jobname .. ".*gf " .. cfg.jobname .. ".*pk " .. beez.char.quote(bin_dir) .. "/ 2>/dev/null || true",
        "&&",
        "mv -f *.gf *.pk " .. beez.char.quote(bin_dir) .. "/ 2>/dev/null || true",
    }, " ")
end

function M.verify_output(cfg, root)
    local bin_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)
    return table.concat({
        "(",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "||",
        "test -n \"$(find " .. bin_dir .. " -maxdepth 1 -name '*.gf' -print -quit 2>/dev/null)\"",
        "||",
        "test -n \"$(find " .. bin_dir .. " -maxdepth 1 -name '*.pk' -print -quit 2>/dev/null)\"",
        ")",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/metafont-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        local input_cmd = "\\mode:=" .. cfg.mode .. "; input " .. cfg.jobname
        parts[#parts + 1] = cfg.mf_binary
        parts[#parts + 1] = "-interaction=nonstopmode"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = beez.char.quote(input_cmd)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
