local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

function M.verify_toolchain(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.mxmlc-setup"
    return table.concat({
        "command -v " .. cfg.mxmlc_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.compile_target(cfg, root, target)
    local out = target.output
    if not out:match("%.swf$") then
        out = out .. ".swf"
        target.output = out
    end
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.mxmlc_binary,
        "+output=" .. beez.char.quote(root .. "/" .. out),
    }
    if cfg.compile_flags ~= nil and cfg.compile_flags ~= "" then
        parts[#parts + 1] = cfg.compile_flags
    end
    parts[#parts + 1] = target.source
    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        local out = target.output
        if not out:match("%.swf$") then
            out = out .. ".swf"
        end
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. out)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/mxmlc-" .. cfg.profile_name .. ".ok"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "command -v " .. cfg.mxmlc_binary,
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end



return M
