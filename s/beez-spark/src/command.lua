local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.spark-setup"

    return table.concat({
        "command -v " .. cfg.spark_binary,
        "&&",
        "command -v gnat",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_target(cfg, root, target)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.spark_binary,
    }

    if cfg.has_manifest and cfg.manifest_path ~= nil then
        if cfg.manifest_path:match("%.gpr$") then
            parts[#parts + 1] = "-P"
            parts[#parts + 1] = beez.char.quote(cfg.manifest_path)
        else
            parts[#parts + 1] = "-U"
            parts[#parts + 1] = beez.char.quote(target.source)
        end
    else
        parts[#parts + 1] = "-U"
        parts[#parts + 1] = beez.char.quote(target.source)
    end

    if cfg.compile_flag ~= nil and cfg.compile_flag ~= "" then
        parts[#parts + 1] = cfg.compile_flag
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. target.output)

    return table.concat(parts, " ")
end

function M.compile_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_artifacts(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/spark-" .. cfg.profile_name .. ".ok"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end



return M
