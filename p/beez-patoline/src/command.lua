local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_compiler(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.patoline-setup"
    local out_abs = root .. "/" .. cfg.out_dir
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.patoline_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(out_abs),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local out_abs = root .. "/" .. cfg.out_dir
    local output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(out_abs),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source == nil then
        error("patoline plugin: no entry .tli source detected")
    end

    parts[#parts + 1] = cfg.patoline_binary
    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end
    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output)
    parts[#parts + 1] = beez.char.quote(cfg.entry_source)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/patoline-" .. cfg.profile_name .. ".ok"
    local out_abs = root .. "/" .. cfg.out_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = "for f in tests/*.tli test/*.tli *_test.tli; do"
        parts[#parts + 1] = "[ -f \"$f\" ] || continue;"
        parts[#parts + 1] = cfg.patoline_binary
        if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
            parts[#parts + 1] = cfg.compile_args
        end
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(out_abs .. "/$(basename \"$f\" .tli).pdf")
        parts[#parts + 1] = "\"$f\" || exit 1;"
        parts[#parts + 1] = "done"
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
