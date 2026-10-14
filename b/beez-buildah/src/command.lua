local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_buildah(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.buildah-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.buildah_binary,
        "--version",
        "&&",
    }

    if cfg.containerfile ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.containerfile)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local containerfile = cfg.containerfile or "Containerfile"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.buildah_binary,
        "bud",
        "-f",
        beez.char.quote(containerfile),
        "-t",
        beez.char.quote(cfg.image_tag),
        ".",
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.verify_output(cfg, root)
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        cfg.buildah_binary,
        "inspect",
        beez.char.quote(cfg.image_tag),
        ">/dev/null",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/buildah-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.buildah_binary,
        "inspect",
        "--format",
        beez.char.quote("{{.FromImage}}"),
        beez.char.quote(cfg.image_tag),
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
