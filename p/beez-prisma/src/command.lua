local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_prisma(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.prisma-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.prisma_binary,
        "--version",
        "&&",
    }

    if cfg.schema_path ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.schema_path)
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
        cfg.prisma_binary,
        "generate",
    }

    if cfg.schema_path ~= nil then
        parts[#parts + 1] = "--schema"
        parts[#parts + 1] = beez.char.quote(cfg.schema_path)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -d node_modules/.prisma",
        "||",
        "test -d node_modules/@prisma/client",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/prisma-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.prisma_binary,
        "validate",
    }

    if cfg.schema_path ~= nil then
        parts[#parts + 1] = "--schema"
        parts[#parts + 1] = beez.char.quote(cfg.schema_path)
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" and cfg.test_args ~= "--schema" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
