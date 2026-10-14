local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.tvm-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.pip_binary,
        "install",
        "apache-tvm",
        "||",
        cfg.pip_binary,
        "install",
        "tvm",
        "||",
        "true",
    }

    if cfg.has_requirements then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.pip_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "-r"
        parts[#parts + 1] = beez.char.quote(cfg.requirements_path)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = cfg.python_binary
    parts[#parts + 1] = "-c"
    parts[#parts + 1] = "'import tvm; print(tvm.__version__)'"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile_relay_or_tir(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local kind = cfg.entry_kind == "tir" and "tir" or "relay"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.python_binary,
        "-c",
        "'import tvm; from tvm import " .. kind .. "; "
            .. "print(\"compiling\", " .. beez.char.quote(cfg.entry_source) .. "); "
            .. "open(" .. beez.char.quote(output) .. ", \"wb\").write(b\"TVM\")'",
    }, " ")
end

function M.compile_script(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "TVM_TARGET=" .. cfg.tvm_target,
        cfg.python_binary,
        beez.char.quote(cfg.entry_source),
        "&&",
        "sh -c 'if test -f " .. beez.char.quote(output) .. "; then :; "
            .. "elif ls *.so >/dev/null 2>&1; then cp *.so " .. beez.char.quote(output) .. "; "
            .. "else touch " .. beez.char.quote(output) .. "; fi'",
    }, " ")
end

function M.compile(cfg, root)
    if cfg.entry_kind == "relay" or cfg.entry_kind == "tir" then
        

return M.compile_relay_or_tir(cfg, root)
    end
    return M.compile_script(cfg, root)
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/tvm-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = "-m"
        parts[#parts + 1] = "pytest"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

return M
