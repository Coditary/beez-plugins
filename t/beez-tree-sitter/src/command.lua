local M = {}

local function grammar_cd(cfg, root)
    local dir = root
    if cfg.grammar_root ~= "." and cfg.grammar_root ~= "" then
        dir = root .. "/" .. cfg.grammar_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_tree_sitter(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.tree-sitter-setup"
    return table.concat({
        grammar_cd(cfg, root),
        "&&",
        cfg.tree_sitter_binary,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local generated = root .. "/" .. cfg.grammar_root .. "/src/parser.c"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        grammar_cd(cfg, root),
        "&&",
        cfg.tree_sitter_binary,
        "generate",
    }

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = cfg.compile_args
    end

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "cp"
    parts[#parts + 1] = beez.char.quote(generated)
    parts[#parts + 1] = beez.char.quote(output)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/tree-sitter-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        grammar_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.tree_sitter_binary
        parts[#parts + 1] = "test"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
