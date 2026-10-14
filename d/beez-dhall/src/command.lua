local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_dhall(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.dhall-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.dhall_binary,
        "--version",
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.dhall_binary
        parts[#parts + 1] = "resolve"
        parts[#parts + 1] = "--no-cache"
        parts[#parts + 1] = "--file"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        if cfg.output_format == "yaml" then
            parts[#parts + 1] = cfg.dhall_to_yaml
        else
            parts[#parts + 1] = cfg.dhall_to_json
        end
        parts[#parts + 1] = "--file"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = ">"
        parts[#parts + 1] = beez.char.quote(ok_file)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "test -s " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/dhall-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.dhall_binary
        parts[#parts + 1] = "format"
        parts[#parts + 1] = "--check"
        parts[#parts + 1] = "--file"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
