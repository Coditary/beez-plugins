local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.abc-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.abcm2ps_binary,
        "-V",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local bin_dir = root .. "/" .. cfg.bin_dir
    local ps_output = bin_dir .. "/app.ps"
    local pdf_output = bin_dir .. "/app.pdf"
    local parts = {
        "mkdir -p " .. beez.char.quote(bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.abcm2ps_binary,
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = "-O"
    parts[#parts + 1] = beez.char.quote(bin_dir .. "/app")
    parts[#parts + 1] = beez.char.quote(cfg.entry_source)

    if cfg.output_name:match("%.pdf$") then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.ps2pdf_binary
        parts[#parts + 1] = beez.char.quote(ps_output)
        parts[#parts + 1] = beez.char.quote(pdf_output)
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/abc-" .. cfg.profile_name .. ".ok"
    local test_ps = root .. "/" .. cfg.bin_dir .. "/test.ps"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.abcm2ps_binary
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "-O"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.bin_dir .. "/test")
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "test -f " .. beez.char.quote(test_ps)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
