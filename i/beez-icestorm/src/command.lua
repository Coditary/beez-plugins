local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_icestorm(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.icestorm-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.yosys_binary,
        "-V",
        "&&",
        cfg.nextpnr_binary,
        "--version",
        "&&",
        cfg.icepack_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local json_out = root .. "/" .. cfg.json_output
    local asc_out = root .. "/" .. cfg.asc_output
    local bin_out = root .. "/" .. cfg.primary_output

    local synth_parts = {}
    for _, source in ipairs(cfg.sources) do
        synth_parts[#synth_parts + 1] = "read_verilog " .. beez.char.quote(source)
    end
    synth_parts[#synth_parts + 1] = "hierarchy -check -top " .. cfg.top_module
    synth_parts[#synth_parts + 1] = "synth_ice40 -top " .. cfg.top_module
    synth_parts[#synth_parts + 1] = "write_json " .. beez.char.quote(json_out)
    local synth_script = table.concat(synth_parts, "; ")

    local nextpnr_parts = {
        cfg.nextpnr_binary,
        "--" .. cfg.fpga_device,
        "--package",
        cfg.fpga_package,
        "--json",
        beez.char.quote(json_out),
        "--asc",
        beez.char.quote(asc_out),
    }

    if cfg.pcf_file ~= nil then
        nextpnr_parts[#nextpnr_parts + 1] = "--pcf"
        nextpnr_parts[#nextpnr_parts + 1] = beez.char.quote(cfg.pcf_file)
    end

    if cfg.profile_name == "debug" then
        nextpnr_parts[#nextpnr_parts + 1] = "-v"
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.yosys_binary,
        "-p",
        beez.char.quote(synth_script),
        "&&",
        table.concat(nextpnr_parts, " "),
        "&&",
        cfg.icepack_binary,
        beez.char.quote(asc_out),
        beez.char.quote(bin_out),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/icestorm-" .. cfg.profile_name .. ".ok"
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
