local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tool(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.asciidoctor-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.asciidoctor_binary,
        "--version",
    }

    if cfg.use_pdf then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.asciidoctor_pdf_binary
        parts[#parts + 1] = "--version"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local binary = cfg.use_pdf and cfg.asciidoctor_pdf_binary or cfg.asciidoctor_binary
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.out_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        binary,
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output)
    parts[#parts + 1] = cfg.entry_source

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/asciidoctor-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.asciidoctor_binary
        parts[#parts + 1] = "--safe-mode"
        parts[#parts + 1] = "secure"
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.out_dir .. "/tests.html")
        parts[#parts + 1] = "tests"
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
