local M = {}

local function source_dir(root, source_path)
    local dir = source_path:match("^(.*)/[^/]+$")
    if dir == nil or dir == "" then
        return root
    end
    return root .. "/" .. dir
end

local function tpc_output_flags(cfg, root)
    return table.concat({
        "/E" .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "/O" .. beez.char.quote(root .. "/" .. cfg.obj_dir),
    }, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.turbopascal-setup-ok"
    return table.concat({
        cfg.tpc_binary,
        "/?",
        "||",
        cfg.tpc_binary,
        "-?",
        "||",
        "true",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_target(cfg, root, target)
    local work_dir = source_dir(root, target.source)
    local source_name = target.source:match("([^/]+)$")

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        "cd " .. beez.char.quote(work_dir),
        "&&",
        cfg.tpc_binary,
        cfg.tpc_args,
        tpc_output_flags(cfg, root),
        beez.char.quote(source_name),
    }

    return table.concat(parts, " ")
end

function M.build_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.run_target(cfg, root, target)
    local exe = root .. "/" .. target.output
    if cfg.run_binary ~= nil and cfg.run_binary ~= "" then
        return cfg.run_binary .. " " .. beez.char.quote(exe)
    end
    return beez.char.quote(exe)
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/turbopascal-" .. cfg.profile_name .. ".ok"

    if #cfg.test_targets == 0 then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(report),
        }, " ")
    end

    local commands = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    for _, target in ipairs(cfg.test_targets) do
        commands[#commands + 1] = "&&"
        commands[#commands + 1] = M.build_target(cfg, root, target)
        commands[#commands + 1] = "&&"
        commands[#commands + 1] = M.run_target(cfg, root, target)
    end

    commands[#commands + 1] = "&&"
    commands[#commands + 1] = "touch " .. beez.char.quote(report)

    return table.concat(commands, " ")
end

return M
