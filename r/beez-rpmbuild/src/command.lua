local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_rpmbuild(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.rpmbuild-setup"
    local topdir = root .. "/" .. cfg.topdir
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.rpmbuild_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(topdir .. "/{BUILD,RPMS,SOURCES,SPECS,SRPMS}"),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local topdir = root .. "/" .. cfg.topdir
    local target = cfg.entry_source
    if target == nil then
        error("rpmbuild compile: no spec file detected")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.rpmbuild_binary,
        "-ba",
        "--define",
        beez.char.quote("_topdir " .. topdir),
        "--define",
        beez.char.quote("_rpmdir " .. topdir .. "/" .. cfg.rpm_output),
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "-vv"
    end

    parts[#parts + 1] = beez.char.quote(target)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local topdir = root .. "/" .. cfg.topdir
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -d " .. beez.char.quote(topdir .. "/" .. cfg.rpm_output),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/rpmbuild-" .. cfg.profile_name .. ".ok"
    local target = cfg.entry_source
    if target == nil then
        error("rpmbuild test: no spec file detected")
    end

    local topdir = root .. "/" .. cfg.topdir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.rpmbuild_binary,
        "--define",
        beez.char.quote("_topdir " .. topdir),
        "-bp",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = beez.char.quote(target)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
