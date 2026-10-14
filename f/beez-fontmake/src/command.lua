local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function entry_flag(cfg)
    if cfg.entry_kind == "designspace" then
        return "-m"
    end
    if cfg.entry_kind == "glyphs" then
        return "-g"
    end
    if cfg.entry_kind == "ufo" then
        return "-u"
    end
    error("fontmake plugin: unsupported entry kind for " .. tostring(cfg.entry_source))
end

local function output_format_args(cfg)
    local parts = {}
    for _, fmt in ipairs(cfg.output_formats) do
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = fmt
    end
    return table.concat(parts, " ")
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.fontmake-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.fontmake_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)
    local parts = {
        "mkdir -p " .. output_dir,
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.fontmake_binary,
        entry_flag(cfg),
        beez.char.quote(cfg.entry_source),
        output_format_args(cfg),
        "--output-dir",
        output_dir,
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    local bin_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)
    return table.concat({
        "(",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "||",
        "test -n \"$(find " .. bin_dir .. " -maxdepth 1 \\( -name '*.otf' -o -name '*.ttf' \\) -print -quit 2>/dev/null)\"",
        ")",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/fontmake-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.fontmake_binary
        parts[#parts + 1] = entry_flag(cfg)
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = "ttf"
        parts[#parts + 1] = "--output-dir"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.bin_dir)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
