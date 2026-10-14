local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_structurizr(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.structurizr-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.structurizr_binary,
        "validate",
        "-workspace",
        beez.char.quote(cfg.entry_source),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local export_dir = root .. "/" .. cfg.bin_dir
    local ok_file = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(export_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.structurizr_binary,
        "export",
        "-workspace",
        beez.char.quote(cfg.entry_source),
        "-output",
        beez.char.quote(export_dir),
        "-format",
        cfg.export_format,
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/structurizr-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.structurizr_binary
        parts[#parts + 1] = "validate"
        parts[#parts + 1] = "-workspace"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
