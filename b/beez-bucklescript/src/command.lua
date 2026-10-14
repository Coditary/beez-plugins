local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function copy_bsb_artifacts(root, cfg)
    local js_dir = beez.char.quote(root .. "/" .. cfg.js_dir)
    local bs_dir = beez.char.quote(root .. "/" .. cfg.bs_dir)

    return table.concat({
        "if [ -d lib/js ]; then",
        "mkdir -p " .. js_dir,
        "&& cp -a lib/js/. " .. js_dir .. "/;",
        "fi",
        "&&",
        "if [ -d lib/bs ]; then",
        "mkdir -p " .. bs_dir,
        "&& cp -a lib/bs/. " .. bs_dir .. "/;",
        "fi",
    }, " ")
end

function M.npm_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.bucklescript-setup"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "install",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bs_dir),
        "&&",
        cfg.bsb_binary,
    }

    if cfg.bsb_args ~= nil and cfg.bsb_args ~= "" then
        parts[#parts + 1] = cfg.bsb_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = copy_bsb_artifacts(root, cfg)

    return table.concat(parts, " ")
end

function M.verify_dist(cfg, root)
    local js_dir = root .. "/" .. cfg.js_dir
    local bs_dir = root .. "/" .. cfg.bs_dir

    return table.concat({
        "( test -d " .. beez.char.quote(js_dir),
        "&& test -n \"$(ls -A " .. beez.char.quote(js_dir) .. " 2>/dev/null)\" )",
        "|| ( test -d " .. beez.char.quote(bs_dir),
        "&& test -n \"$(ls -A " .. beez.char.quote(bs_dir) .. " 2>/dev/null)\" )",
        "|| ( test -d lib/js && test -n \"$(ls -A lib/js 2>/dev/null)\" )",
        "|| ( test -d lib/bs && test -n \"$(ls -A lib/bs 2>/dev/null)\" )",
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/bucklescript-" .. cfg.profile_name .. ".ok"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(ok_file),
        }, " ")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = "--"
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end


function M.run(cfg, root)
    local run_args = beez.env_or("BEEZ_RUN_ARGS", cfg.run_args or "")

    if cfg.run_command ~= nil and cfg.run_command ~= "" then
        if run_args ~= "" then
            return cfg.run_command .. " " .. run_args
        end
        return cfg.run_command
    end

    if cfg.primary_source ~= nil then
        local interpreter = cfg.interpreter_binary
        if interpreter == nil or interpreter == "" then
            error("run: primary_source set but no interpreter_binary in config")
        end
        local parts = {}
        if cfg.project_root ~= nil and cfg.project_root ~= "." and cfg.project_root ~= "" then
            parts[#parts + 1] = "cd " .. beez.char.quote(root .. "/" .. cfg.project_root)
            parts[#parts + 1] = "&&"
        end
        parts[#parts + 1] = interpreter
        parts[#parts + 1] = cfg.primary_source
        if run_args ~= "" then
            parts[#parts + 1] = run_args
        end
        return table.concat(parts, " ")
    end

    if cfg.primary_output ~= nil then
        local exe = root .. "/" .. cfg.primary_output
        local parts = {
            "(",
            "test -x " .. beez.char.quote(exe),
            "||",
            "test -f " .. beez.char.quote(exe),
            ")",
            "&&",
            beez.char.quote(exe),
        }
        if run_args ~= "" then
            parts[#parts + 1] = run_args
        end
        return table.concat(parts, " ")
    end

    if cfg.build_tree ~= nil then
        local bin_dir = root .. "/" .. cfg.build_tree .. "/bin"
        local shell = "set -e; bin=$(find "
            .. beez.char.quote(bin_dir)
            .. " -type f \\( -perm -111 -o -name '*.wasm' -o -name '*.js' \\) 2>/dev/null | head -n1); "
            .. "if [ -z \"$bin\" ]; then echo 'run: no executable in "
            .. cfg.build_tree
            .. "/bin' >&2; exit 1; fi; exec \"$bin\""
        if run_args ~= "" then
            shell = shell .. " " .. run_args
        end
        return "sh -c " .. beez.char.quote(shell)
    end

    error("run: no run target configured")
end

return M
