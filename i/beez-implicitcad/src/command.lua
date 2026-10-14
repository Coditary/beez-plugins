local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_implicitcad(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.implicitcad-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        "(",
        cfg.extopenscad_binary,
        "--version",
        "||",
        cfg.implicitcad_binary,
        "--version",
        ")",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_scad(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "(",
        cfg.extopenscad_binary,
        "-o",
        beez.char.quote(output),
        beez.char.quote(cfg.entry_source),
        "||",
        cfg.implicitcad_binary,
        "-o",
        beez.char.quote(output),
        beez.char.quote(cfg.entry_source),
        ")",
    }, " ")
end

function M.compile_hs(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "IMPLICITCAD_OUTPUT=" .. beez.char.quote(output),
        "IMPLICITCAD_FORMAT=" .. cfg.output_format,
        cfg.runhaskell_binary,
        beez.char.quote(cfg.entry_source),
    }, " ")
end

function M.compile(cfg, root)
    if cfg.source_kind == "hs" then
        

return M.compile_hs(cfg, root)
    end

    return M.compile_scad(cfg, root)
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/implicitcad-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        local test_output = root .. "/" .. cfg.bin_dir .. "/test." .. cfg.output_format
        if cfg.source_kind == "hs" then
            parts[#parts + 1] = "IMPLICITCAD_OUTPUT=" .. beez.char.quote(test_output)
            parts[#parts + 1] = "IMPLICITCAD_FORMAT=" .. cfg.output_format
            parts[#parts + 1] = cfg.runhaskell_binary
            parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        else
            parts[#parts + 1] = "("
            parts[#parts + 1] = cfg.extopenscad_binary
            parts[#parts + 1] = "-o"
            parts[#parts + 1] = beez.char.quote(test_output)
            parts[#parts + 1] = beez.char.quote(cfg.entry_source)
            parts[#parts + 1] = "||"
            parts[#parts + 1] = cfg.implicitcad_binary
            parts[#parts + 1] = "-o"
            parts[#parts + 1] = beez.char.quote(test_output)
            parts[#parts + 1] = beez.char.quote(cfg.entry_source)
            parts[#parts + 1] = ")"
        end
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
