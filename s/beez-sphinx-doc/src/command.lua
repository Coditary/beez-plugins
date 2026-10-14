local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_sphinx(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.sphinx-doc-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.sphinx_build_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output_dir = root .. "/" .. cfg.bin_dir
    local doctree_dir = root .. "/" .. cfg.build_dir .. "/doctrees"
    return table.concat({
        "mkdir -p " .. beez.char.quote(output_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(doctree_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.sphinx_build_binary,
        "-b",
        cfg.builder,
        "-d",
        beez.char.quote(doctree_dir),
        beez.char.quote(cfg.source_dir),
        beez.char.quote(output_dir),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/sphinx-doc-" .. cfg.profile_name .. ".ok"
    local linkcheck_dir = root .. "/" .. cfg.build_dir .. "/linkcheck"
    local doctree_dir = root .. "/" .. cfg.build_dir .. "/doctrees-linkcheck"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests or cfg.conf_py ~= nil then
        parts[#parts + 1] = "mkdir -p " .. beez.char.quote(linkcheck_dir)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "mkdir -p " .. beez.char.quote(doctree_dir)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.sphinx_build_binary
        parts[#parts + 1] = "-b"
        parts[#parts + 1] = cfg.test_builder
        parts[#parts + 1] = "-d"
        parts[#parts + 1] = beez.char.quote(doctree_dir)
        parts[#parts + 1] = beez.char.quote(cfg.source_dir)
        parts[#parts + 1] = beez.char.quote(linkcheck_dir)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
