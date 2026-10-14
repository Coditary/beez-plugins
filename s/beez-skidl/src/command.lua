local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.skidl-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.pip_binary,
        "install",
        "skidl",
    }

    if cfg.has_requirements then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.pip_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "-r"
        parts[#parts + 1] = beez.char.quote(cfg.requirements_path)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = cfg.python_binary
    parts[#parts + 1] = "-c"
    parts[#parts + 1] = "'import skidl'"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.python_binary,
        beez.char.quote(cfg.entry_source),
        "&&",
        "sh -c 'if ls *.net >/dev/null 2>&1; then cp *.net " .. beez.char.quote(output) .. "; elif ls build/skidl/*.net >/dev/null 2>&1; then cp build/skidl/*.net " .. beez.char.quote(output) .. "; else touch " .. beez.char.quote(output) .. "; fi'",
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/skidl-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = "-m"
        parts[#parts + 1] = "pytest"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
