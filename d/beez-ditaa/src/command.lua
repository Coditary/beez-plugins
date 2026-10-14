local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.extract_ditaa_from_markdown(cfg, root)
    local extracted = root .. "/" .. cfg.build_dir .. "/.ditaa-input.txt"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "awk '/^```ditaa/{flag=1;next} /^```/{flag=0} flag' "
            .. beez.char.quote(cfg.entry_source)
            .. " > "
            .. beez.char.quote(extracted),
    }, " ")
end

function M.ditaa_input_path(cfg, root)
    if cfg.entry_is_markdown then
        return root .. "/" .. cfg.build_dir .. "/.ditaa-input.txt"
    end
    return cfg.entry_source
end

function M.verify_ditaa(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ditaa-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.ditaa_binary,
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

    if cfg.entry_is_markdown then
        parts[#parts + 1] = M.extract_ditaa_from_markdown(cfg, root)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = cfg.ditaa_binary
    parts[#parts + 1] = beez.char.quote(M.ditaa_input_path(cfg, root))
    parts[#parts + 1] = beez.char.quote(output)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/ditaa-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        if cfg.entry_is_markdown then
            parts[#parts + 1] = M.extract_ditaa_from_markdown(cfg, root)
            parts[#parts + 1] = "&&"
        end
        parts[#parts + 1] = cfg.ditaa_binary
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = beez.char.quote(M.ditaa_input_path(cfg, root))
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.bin_dir .. "/test.png")
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
