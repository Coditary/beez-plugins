local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.amaranth-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.pip_binary,
        "install",
        "amaranth",
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
    parts[#parts + 1] = "'import amaranth'"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local rtl_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.rtl_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "sh -c 'if ls *.v >/dev/null 2>&1; then cp *.v "
        .. beez.char.quote(rtl_file)
        .. "; elif ls build/amaranth/bin/*.v >/dev/null 2>&1; then cp build/amaranth/bin/*.v "
        .. beez.char.quote(rtl_file)
        .. "; else touch "
        .. beez.char.quote(rtl_file)
        .. "; fi'"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local rtl_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.rtl_output
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -f " .. beez.char.quote(rtl_file),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/amaranth-" .. cfg.profile_name .. ".ok"
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
    elseif cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = "-m"
        parts[#parts + 1] = "py_compile"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
