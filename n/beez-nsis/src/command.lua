local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function qsource(cfg, root, target)
    return beez.char.quote(root .. "/" .. target.source)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.nsis-setup"

    return table.concat({
        "command -v " .. cfg.makensis_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_target(cfg, root, target)
    local qs = qsource(cfg, root, target)

    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.makensis_binary .. " /V2 " .. qs,
    }, " ")
end

function M.syntax_check_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end

    local stamp = root .. "/" .. cfg.compile_stamp
    commands[#commands + 1] = table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")

    return table.concat(commands, " && ")
end

function M.verify_compile_stamp(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.compile_stamp)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/nsis-" .. cfg.profile_name .. ".ok"
    local target = { source = cfg.primary_source, name = "app" }
    local qs = qsource(cfg, root, target)
    
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.makensis_binary .. " /V2 " .. qs,
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end



return M
