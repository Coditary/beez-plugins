local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_dir ~= nil and cfg.project_dir ~= "" and cfg.project_dir ~= "." then
        if cfg.project_root ~= "." and cfg.project_root ~= "" then
            dir = root .. "/" .. cfg.project_dir
        else
            dir = cfg.project_dir
        end
    elseif cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.doxygen-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.doxygen_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output_dir = root .. "/" .. cfg.bin_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(output_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.doxyfile ~= nil then
        parts[#parts + 1] = cfg.doxygen_binary
        parts[#parts + 1] = beez.char.quote(cfg.doxyfile)
    else
        parts[#parts + 1] = "printf"
        parts[#parts + 1] = "'PROJECT_NAME = app\\nOUTPUT_DIRECTORY = "
        parts[#parts + 1] = beez.char.quote(output_dir)
        parts[#parts + 1] = "\\nINPUT = .\\nRECURSIVE = YES\\nGENERATE_HTML = YES\\n'"
        parts[#parts + 1] = "|"
        parts[#parts + 1] = cfg.doxygen_binary
        parts[#parts + 1] = "-"
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/doxygen-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.doxyfile ~= nil then
        parts[#parts + 1] = cfg.doxygen_binary
        parts[#parts + 1] = "-s"
        parts[#parts + 1] = beez.char.quote(cfg.doxyfile)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
