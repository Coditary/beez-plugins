local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_groff(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.groff-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.groff_binary,
        "--version",
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
        cfg.groff_binary,
    }

    if cfg.macro_package ~= nil and cfg.macro_package ~= "" then
        parts[#parts + 1] = cfg.macro_package
    end

    parts[#parts + 1] = "-T" .. cfg.output_format
    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output)
    parts[#parts + 1] = beez.char.quote(cfg.entry_source)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/groff-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.groff_binary
        if cfg.macro_package ~= nil and cfg.macro_package ~= "" then
            parts[#parts + 1] = cfg.macro_package
        end
        parts[#parts + 1] = "-Tascii"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = ">/dev/null"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
