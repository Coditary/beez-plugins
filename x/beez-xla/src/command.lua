local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function xla_opt_invocation(cfg)
    return "(command -v " .. cfg.xla_opt_binary .. " >/dev/null 2>&1 && "
        .. cfg.xla_opt_binary
        .. " || "
        .. cfg.mlir_opt_binary .. ")"
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.xla-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.pip_binary,
        "install",
        "tensorflow",
        "||",
        "true",
        "&&",
        "(command -v " .. cfg.xla_opt_binary .. " >/dev/null 2>&1 || command -v " .. cfg.mlir_opt_binary .. " >/dev/null 2>&1 || "
            .. cfg.python_binary .. " -c 'import tensorflow as tf; print(tf.__version__)')",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_mlir(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local opt = xla_opt_invocation(cfg)
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        opt,
        beez.char.quote(cfg.entry_source),
        "-o",
        beez.char.quote(output),
    }, " ")
end

function M.compile_saved_model(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.python_binary,
        "-c",
        "'import tensorflow as tf; "
            .. "m=tf.saved_model.load(" .. beez.char.quote(cfg.entry_source) .. "); "
            .. "open(" .. beez.char.quote(output) .. ", \"w\").write(str(m))'",
    }, " ")
end

function M.compile_script(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "TF_XLA_FLAGS=--tf_xla_auto_jit=2",
        cfg.python_binary,
        beez.char.quote(cfg.entry_source),
        "&&",
        "touch " .. beez.char.quote(output),
    }, " ")
end

function M.compile(cfg, root)
    if cfg.entry_kind == "saved_model" then
        

return M.compile_saved_model(cfg, root)
    end
    if cfg.entry_kind == "script" then
        return M.compile_script(cfg, root)
    end
    return M.compile_mlir(cfg, root)
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/xla-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests and cfg.entry_kind == "mlir" and cfg.entry_source ~= nil then
        parts[#parts + 1] = xla_opt_invocation(cfg)
        parts[#parts + 1] = "--verify-diagnostics"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

return M
