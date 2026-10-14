local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_menhir(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.menhir-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.menhir_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output_ml = root .. "/" .. cfg.primary_output
    local output_mli = root .. "/" .. cfg.interface_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.menhir_binary,
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = "--base"
    parts[#parts + 1] = cfg.base_name
    parts[#parts + 1] = "--ocamlc"
    parts[#parts + 1] = "--out"
    parts[#parts + 1] = beez.char.quote(output_ml)
    parts[#parts + 1] = "--infer"
    parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "test -f " .. beez.char.quote(output_mli)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.interface_output),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/menhir-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.menhir_binary
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
