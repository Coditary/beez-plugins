local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.remotion-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.remotion_binary,
        "remotion",
        "versions",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.remotion_binary,
        "remotion",
        "render",
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    parts[#parts + 1] = beez.char.quote(cfg.composition_id)
    parts[#parts + 1] = beez.char.quote(output)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/remotion-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.remotion_binary
        parts[#parts + 1] = "remotion"
        parts[#parts + 1] = cfg.test_args or "versions"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
