local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_cadquery(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.cadquery-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.python_binary,
        "-c",
        beez.char.quote("import cadquery; print(cadquery.__version__)"),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "CADQUERY_OUTPUT=" .. beez.char.quote(output),
        "CADQUERY_FORMAT=" .. cfg.output_format,
        cfg.python_binary,
        beez.char.quote(cfg.entry_source),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/cadquery-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        local test_output = root .. "/" .. cfg.bin_dir .. "/test." .. cfg.output_format
        parts[#parts + 1] = "CADQUERY_OUTPUT=" .. beez.char.quote(test_output)
        parts[#parts + 1] = "CADQUERY_FORMAT=" .. cfg.output_format
        parts[#parts + 1] = cfg.python_binary
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
