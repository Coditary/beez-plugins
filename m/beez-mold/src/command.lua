local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_mold(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.mold-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.mold_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.mold_binary,
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output)

    for _, object_file in ipairs(cfg.object_files) do
        parts[#parts + 1] = beez.char.quote(object_file)
    end

    if #cfg.object_files == 0 then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.compdb or "compile_commands.json")
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/mold-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.mold_binary
        parts[#parts + 1] = cfg.test_args
        parts[#parts + 1] = "&&"
    end

    if cfg.compdb ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.compdb)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
