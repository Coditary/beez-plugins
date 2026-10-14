local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

function M.verify_toolchain(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.royale-setup"
    return table.concat({
        "(command -v " .. cfg.royale_binary .. " || command -v " .. cfg.asconfigc_binary .. ")",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_asconfig(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "(command -v " .. cfg.asconfigc_binary .. " >/dev/null 2>&1 && echo " .. cfg.asconfigc_binary .. " || echo " .. cfg.royale_binary .. ")",
        " | xargs -I{} {}",
    }

    if cfg.compile_flags ~= nil and cfg.compile_flags ~= "" then
        parts[#parts + 1] = cfg.compile_flags
    end

    if cfg.asconfig_path ~= nil then
        parts[#parts + 1] = "--project"
        parts[#parts + 1] = beez.char.quote(cfg.asconfig_path)
    end

    return table.concat(parts, " ")
end

function M.compile_target(cfg, root, target)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.royale_binary,
        "--targets",
        beez.char.quote(cfg.royale_target),
        "-output",
        beez.char.quote(root .. "/" .. target.output),
    }

    if cfg.compile_flags ~= nil and cfg.compile_flags ~= "" then
        parts[#parts + 1] = cfg.compile_flags
    end

    parts[#parts + 1] = target.source
    return table.concat(parts, " ")
end

function M.compile_all(cfg, root)
    if cfg.build_mode == "asconfig" then
        

return M.compile_asconfig(cfg, root)
    end

    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_artifacts(cfg, root)
    if cfg.build_mode == "asconfig" then
        return "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/royale-" .. cfg.profile_name .. ".ok"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "(command -v " .. cfg.royale_binary .. " || command -v " .. cfg.asconfigc_binary .. ")",
        "&&",
        M.verify_artifacts(cfg, root),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

return M
