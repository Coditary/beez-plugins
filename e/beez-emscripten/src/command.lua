local M = {}

function M.setup(config, root)
    local stamp = root .. "/" .. config.build_tree .. "/.emscripten-prepared"
    return table.concat({
        "mkdir -p " .. beez.char.quote(config.build_tree_abs),
        "&& " .. config.cc .. " --version",
        "&& " .. config.cxx .. " --version",
        "&& touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(config, entry)
    return "bash " .. beez.char.quote(entry.script)
end

function M.bundle(config, link_entry)
    return "bash " .. beez.char.quote(link_entry.script)
end

function M.index(config, root)
    local script = root .. "/" .. config.index_script
    local parts = {
        "CC=" .. beez.char.quote(config.cc),
        "CXX=" .. beez.char.quote(config.cxx),
        "EMSCRIPTEN_COMPILE_OPT=" .. beez.char.quote(config.compile_opt),
        config.python_binary,
        beez.char.quote(script),
        beez.char.quote(config.build_tree_abs),
        beez.char.quote(config.index_lua_abs),
    }

    return table.concat(parts, " ")
end

function M.test(config, root)
    local report_ok = root .. "/" .. config.reports_dir .. "/test/emscripten-wasm.ok"
    local report_dir = root .. "/" .. config.reports_dir .. "/test"

    return table.concat({
        "mkdir -p " .. beez.char.quote(report_dir),
        "&& cd " .. beez.char.quote(config.build_tree_abs),
        "&& ctest " .. config.ctest_args,
        "&& touch " .. beez.char.quote(report_ok),
    }, " ")
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
