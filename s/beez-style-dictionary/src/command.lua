local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function style_dictionary_invocation(cfg)
    if cfg.style_dictionary_binary == "style-dictionary" then
        return "(command -v style-dictionary >/dev/null 2>&1 && style-dictionary || "
            .. cfg.npx_binary
            .. " --yes style-dictionary)"
    end

    return cfg.style_dictionary_binary
end

function M.npm_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.style-dictionary-setup"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "install",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build(cfg, root)
    local sd = style_dictionary_invocation(cfg)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.dist_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        sd,
        "build",
    }

    if cfg.config_path ~= nil then
        parts[#parts + 1] = "--config"
        parts[#parts + 1] = beez.char.quote(cfg.config_path)
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return table.concat({
        "test -d " .. beez.char.quote(root .. "/" .. cfg.dist_dir),
        "||",
        "test -n \"$(find " .. beez.char.quote(root .. "/.") .. " -path '*/build/*' -o -path '*/dist/*' -name '*.css' -print -quit 2>/dev/null)\"",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/style-dictionary-" .. cfg.profile_name .. ".ok"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(ok_file),
        }, " ")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = "--"
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
