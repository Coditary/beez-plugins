local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_yosys(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.yosys-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.yosys_binary,
        "-V",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local script_parts = {}

    for _, source in ipairs(cfg.sources) do
        script_parts[#script_parts + 1] = "read_verilog " .. beez.char.quote(source)
    end

    script_parts[#script_parts + 1] = "hierarchy -check -top " .. cfg.top_module
    script_parts[#script_parts + 1] = cfg.synth_script
    script_parts[#script_parts + 1] = "write_verilog " .. beez.char.quote(output)

    local script = table.concat(script_parts, "; ")

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.yosys_binary,
        "-p",
        beez.char.quote(script),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/yosys-" .. cfg.profile_name .. ".ok"
    local check_script = table.concat({
        "read_verilog " .. beez.char.quote(cfg.top_source),
        "hierarchy -check -top " .. cfg.top_module,
        "check",
    }, "; ")

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.top_source ~= nil then
        parts[#parts + 1] = cfg.yosys_binary
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "-p"
        parts[#parts + 1] = beez.char.quote(check_script)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
