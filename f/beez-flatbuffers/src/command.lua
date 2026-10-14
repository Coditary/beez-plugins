local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_flatc(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.flatbuffers-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.flatc_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local output_dir = root .. "/" .. cfg.bin_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(output_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.flatc_binary,
        "-o",
        beez.char.quote(output_dir),
        "--cpp",
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local output_dir = root .. "/" .. cfg.bin_dir
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -n \"$(find " .. beez.char.quote(output_dir) .. " -maxdepth 1 -name '*.h' -print -quit)\"",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/flatbuffers-" .. cfg.profile_name .. ".ok"
    local output_dir = root .. "/" .. cfg.bin_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.flatc_binary
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(output_dir .. "/test")
        parts[#parts + 1] = "--cpp"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
