local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_mock(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.mock-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.mock_binary,
        "--version",
        "&&",
    }

    if cfg.has_mock_config and cfg.mock_config_file ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.mock_config_file)
        parts[#parts + 1] = "&&"
    else
        parts[#parts + 1] = cfg.mock_binary
        parts[#parts + 1] = "--listchroots"
        parts[#parts + 1] = ">/dev/null"
        parts[#parts + 1] = "||"
        parts[#parts + 1] = "true"
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local result_dir = root .. "/" .. cfg.bin_dir .. "/" .. cfg.result_dir
    local target = cfg.entry_source
    if target == nil then
        error("mock compile: no spec file detected")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(result_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.mock_binary,
        "-r",
        beez.char.quote(cfg.mock_config),
        "--resultdir",
        beez.char.quote(result_dir),
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "-v"
    end

    parts[#parts + 1] = beez.char.quote(target)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local result_dir = root .. "/" .. cfg.bin_dir .. "/" .. cfg.result_dir
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -d " .. beez.char.quote(result_dir),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/mock-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.mock_binary,
        "--print-plugin-path",
        ">/dev/null",
        "&&",
    }

    if cfg.has_mock_config and cfg.mock_config_file ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.mock_config_file)
        parts[#parts + 1] = "&&"
    end

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
