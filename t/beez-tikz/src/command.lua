local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tikz(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.tikz-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.latex_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local bin_path = root .. "/" .. cfg.bin_dir
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(bin_path),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.latex_binary,
        "-interaction=nonstopmode",
        "-halt-on-error",
        "-jobname=app",
        "-output-directory=" .. beez.char.quote(bin_path),
        beez.char.quote(cfg.entry_source),
        "&&",
        "test -f " .. beez.char.quote(output),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/tikz-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.latex_binary
        parts[#parts + 1] = "-interaction=nonstopmode"
        parts[#parts + 1] = "-halt-on-error"
        parts[#parts + 1] = "-jobname=test"
        parts[#parts + 1] = "-output-directory=" .. beez.char.quote(root .. "/" .. cfg.bin_dir)
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
