local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_gnuplot(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.gnuplot-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.gnuplot_binary,
        "--version",
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
        cfg.gnuplot_binary,
        "-e",
        beez.char.quote(
            "set terminal " .. cfg.terminal .. "; "
                .. "set output '" .. output .. "'; "
                .. "load '" .. cfg.entry_source .. "'"
        ),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/gnuplot-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        local test_output = root .. "/" .. cfg.bin_dir .. "/test." .. cfg.terminal
        parts[#parts + 1] = cfg.gnuplot_binary
        parts[#parts + 1] = "-e"
        parts[#parts + 1] = beez.char.quote(
            "set terminal " .. cfg.terminal .. "; "
                .. "set output '" .. test_output .. "'; "
                .. "load '" .. cfg.entry_source .. "'"
        )
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
