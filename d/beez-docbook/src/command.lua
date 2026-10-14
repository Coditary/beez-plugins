local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tools(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.docbook-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.xsltproc_binary,
        "--version",
        "&&",
        cfg.fop_binary,
        "-version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local out_dir = root .. "/" .. cfg.out_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(out_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.output_format == "pdf" then
        local fo_file = out_dir .. "/app.fo"
        parts[#parts + 1] = cfg.xsltproc_binary
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(fo_file)
        parts[#parts + 1] = beez.char.quote(cfg.fo_stylesheet)
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.fop_binary
        parts[#parts + 1] = beez.char.quote(fo_file)
        parts[#parts + 1] = beez.char.quote(output)
    else
        parts[#parts + 1] = cfg.xsltproc_binary
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(output)
        parts[#parts + 1] = beez.char.quote(cfg.stylesheet)
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/docbook-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = "xmllint --noout"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
