local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_buildroot(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.buildroot-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        "test -f Makefile",
        "&&",
        cfg.make_binary,
        "--version",
        "&&",
    }

    if cfg.defconfig_target ~= nil then
        parts[#parts + 1] = cfg.make_binary
        parts[#parts + 1] = beez.char.quote(cfg.defconfig_target)
        parts[#parts + 1] = "&&"
    elseif cfg.defconfig ~= nil then
        parts[#parts + 1] = "cp"
        parts[#parts + 1] = beez.char.quote(cfg.defconfig)
        parts[#parts + 1] = ".config"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.make_binary
        parts[#parts + 1] = "olddefconfig"
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local output_dir = root .. "/" .. cfg.output_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.make_binary,
        "O=" .. beez.char.quote(output_dir),
    }

    if cfg.profile_name == "debug" and cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local output_dir = root .. "/" .. cfg.output_dir
    local image_dir = output_dir .. "/images"
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -d " .. beez.char.quote(output_dir),
        "&&",
        "( test -d " .. beez.char.quote(image_dir) .. " || test -f " .. beez.char.quote(output_dir .. "/.config") .. " )",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/buildroot-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_config_in then
        parts[#parts + 1] = "test -f Config.in"
        parts[#parts + 1] = "&&"
    end

    if cfg.defconfig ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.defconfig)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = cfg.make_binary
    parts[#parts + 1] = "printvars"
    parts[#parts + 1] = "V=0"
    parts[#parts + 1] = ">/dev/null"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
