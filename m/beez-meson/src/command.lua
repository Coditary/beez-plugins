local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_meson(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.meson-setup"
    local meson_dir = root .. "/" .. cfg.meson_build_dir
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.meson_binary,
        "--version",
        "&&",
        "test -f " .. beez.char.quote(cfg.entry_source),
        "&&",
        cfg.meson_binary,
        "setup",
        beez.char.quote(meson_dir),
        beez.char.quote(cfg.source_dir),
        "--wipe",
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "--buildtype=debug"
    else
        parts[#parts + 1] = "--buildtype=release"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local meson_dir = root .. "/" .. cfg.meson_build_dir
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.meson_binary,
        "compile",
        "-C",
        beez.char.quote(meson_dir),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/meson-" .. cfg.profile_name .. ".ok"
    local meson_dir = root .. "/" .. cfg.meson_build_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.meson_binary,
        "test",
        "-C",
        beez.char.quote(meson_dir),
        "--no-rebuild",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
