local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_compiler(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.tectonic-setup"
    local out_abs = root .. "/" .. cfg.out_dir
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.tectonic_binary,
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
    local parts = {
        "mkdir -p " .. beez.char.quote(out_abs),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tectonic_toml then
        parts[#parts + 1] = cfg.tectonic_binary
        parts[#parts + 1] = "-X"
        parts[#parts + 1] = "build"
        parts[#parts + 1] = "--outdir"
        parts[#parts + 1] = beez.char.quote(out_abs)
        if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
            parts[#parts + 1] = cfg.compile_args
        end
    else
        if cfg.entry_source == nil then
            error("tectonic plugin: no entry .tex source or Tectonic.toml detected")
        end
        parts[#parts + 1] = cfg.tectonic_binary
        parts[#parts + 1] = "--outdir"
        parts[#parts + 1] = beez.char.quote(out_abs)
        if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
            parts[#parts + 1] = cfg.compile_args
        end
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/tectonic-" .. cfg.profile_name .. ".ok"
    local out_abs = root .. "/" .. cfg.out_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = "for f in tests/*.tex test/*.tex *_test.tex; do"
        parts[#parts + 1] = "[ -f \"$f\" ] || continue;"
        parts[#parts + 1] = cfg.tectonic_binary
        parts[#parts + 1] = "--outdir"
        parts[#parts + 1] = beez.char.quote(out_abs)
        if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
            parts[#parts + 1] = cfg.compile_args
        end
        parts[#parts + 1] = "\"$f\" || exit 1;"
        parts[#parts + 1] = "done"
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
