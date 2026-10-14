local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.book_dir ~= nil and cfg.book_dir ~= "" and cfg.book_dir ~= "." then
        if cfg.project_root ~= "." and cfg.project_root ~= "" then
            dir = root .. "/" .. cfg.book_dir
        else
            dir = cfg.book_dir
        end
    elseif cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.mdbook-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.mdbook_binary,
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
        cfg.mdbook_binary,
        "build",
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = "--dest-dir"
    parts[#parts + 1] = beez.char.quote(output_dir)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/mdbook-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests or cfg.book_toml ~= nil then
        parts[#parts + 1] = cfg.mdbook_binary
        parts[#parts + 1] = "test"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
