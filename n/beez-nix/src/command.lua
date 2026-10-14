local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_nix(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.nix-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.nix_binary,
        "--version",
        "&&",
    }

    if cfg.has_flake then
        parts[#parts + 1] = cfg.nix_binary
        parts[#parts + 1] = "flake"
        parts[#parts + 1] = "metadata"
        parts[#parts + 1] = "--no-write-lock-file"
        parts[#parts + 1] = "&&"
    elseif cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.nix_binary
        parts[#parts + 1] = "-instantiate"
        parts[#parts + 1] = "--parse"
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
    local result_link = root .. "/" .. cfg.bin_dir .. "/" .. cfg.result_link
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_flake then
        parts[#parts + 1] = cfg.nix_binary
        parts[#parts + 1] = "build"
        parts[#parts + 1] = "--out-link"
        parts[#parts + 1] = beez.char.quote(result_link)
        parts[#parts + 1] = "&&"
    elseif cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.nix_binary
        parts[#parts + 1] = "-instantiate"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "ln"
        parts[#parts + 1] = "-sf"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = beez.char.quote(result_link)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local result_link = root .. "/" .. cfg.bin_dir .. "/" .. cfg.result_link
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -e " .. beez.char.quote(result_link),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/nix-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_flake then
        parts[#parts + 1] = cfg.nix_binary
        parts[#parts + 1] = "flake"
        parts[#parts + 1] = "check"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    elseif cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.nix_binary
        parts[#parts + 1] = "-instantiate"
        parts[#parts + 1] = "--parse"
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
