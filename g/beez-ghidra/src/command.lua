local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function ghidra_cmd(cfg)
    if cfg.ghidra_home ~= nil and cfg.ghidra_home ~= "" then
        return beez.char.quote(cfg.ghidra_home .. "/support/analyzeHeadless")
    end
    return cfg.ghidra_binary
end

function M.verify_ghidra(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ghidra-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
    }

    if cfg.ghidra_home ~= nil and cfg.ghidra_home ~= "" then
        parts[#parts + 1] = "test -x " .. beez.char.quote(cfg.ghidra_home .. "/support/analyzeHeadless")
        parts[#parts + 1] = "&&"
    else
        parts[#parts + 1] = "command -v " .. cfg.ghidra_binary
        parts[#parts + 1] = ">/dev/null"
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.project_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local report_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.report_name
    local target = cfg.entry_source
    if target == nil then
        error("ghidra compile: no binary target detected")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        ghidra_cmd(cfg),
        beez.char.quote(root .. "/" .. cfg.project_dir),
        beez.char.quote(cfg.project_name),
        "-import",
        beez.char.quote(target),
        "-deleteProject",
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "-log"
        parts[#parts + 1] = beez.char.quote(report_file)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local report_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.report_name
    local parts = {
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "test -f " .. beez.char.quote(report_file)
    end

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/ghidra-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "test -f " .. beez.char.quote(cfg.entry_source)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
