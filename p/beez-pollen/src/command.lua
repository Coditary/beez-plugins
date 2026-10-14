local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_toolchain(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.pollen-setup"
    local out_abs = root .. "/" .. cfg.out_dir
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.raco_binary,
        "pollen",
        "version",
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

    if cfg.entry_source == nil then
        parts[#parts + 1] = cfg.raco_binary
        parts[#parts + 1] = "pollen"
        parts[#parts + 1] = "render"
        if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
            parts[#parts + 1] = cfg.compile_args
        end
    else
        parts[#parts + 1] = cfg.raco_binary
        parts[#parts + 1] = "pollen"
        parts[#parts + 1] = "render"
        if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
            parts[#parts + 1] = cfg.compile_args
        end
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local out_abs = root .. "/" .. cfg.out_dir
    return "test -d " .. beez.char.quote(out_abs) .. " && ls " .. beez.char.quote(out_abs) .. " | grep -q ."
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/pollen-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = "for f in tests/*.pmd test/*.pmd *_test.pmd; do"
        parts[#parts + 1] = "[ -f \"$f\" ] || continue;"
        parts[#parts + 1] = cfg.raco_binary
        parts[#parts + 1] = "pollen"
        parts[#parts + 1] = "render"
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
