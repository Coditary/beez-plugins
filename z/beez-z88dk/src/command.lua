local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_zcc(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.z88dk-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.zcc_binary,
        cfg.z88dk_target,
        "-h",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.zcc_binary
        parts[#parts + 1] = cfg.z88dk_target
        parts[#parts + 1] = "-vn"
        if cfg.optimize ~= nil and cfg.optimize ~= "" then
            parts[#parts + 1] = cfg.optimize
        end
        parts[#parts + 1] = cfg.entry_source
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(output)
        parts[#parts + 1] = "-create-app"
    else
        parts[#parts + 1] = "echo 'z88dk plugin: no entry *.c source found' >&2"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "exit 1"
    end

    return table.concat(parts, " ")
end

function M.verify_binary(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
        .. " || test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output .. ".bin")
        .. " || test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output .. ".tap")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/z88dk-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = "for f in test/*_test.c tests/*_test.c *_test.c; do"
        parts[#parts + 1] = "test -f \"$f\" || continue;"
        parts[#parts + 1] = cfg.zcc_binary
        parts[#parts + 1] = cfg.z88dk_target
        parts[#parts + 1] = "-vn"
        if cfg.optimize ~= nil and cfg.optimize ~= "" then
            parts[#parts + 1] = cfg.optimize
        end
        parts[#parts + 1] = "\"$f\""
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = "\"${f%.c}\""
        parts[#parts + 1] = "-create-app;"
        parts[#parts + 1] = "done"
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
