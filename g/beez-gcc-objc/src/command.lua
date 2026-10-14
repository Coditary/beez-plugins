local M = {}

function M.replace_compiler(command, cxx, cc)
    local first = command:match("^(%S+)")
    if first == nil then
        return command
    end

    if first:find("g%+%+", 1, true) or first:find("clang%+%+", 1, true) then
        return cxx .. command:sub(#first + 1)
    end

    if first:find("gcc", 1, true) or first:find("clang", 1, true) then
        return cc .. command:sub(#first + 1)
    end

    return command
end

function M.compile(config, entry)
    return "bash " .. beez.char.quote(entry.script)
end

function M.link(config, link_entry)
    return "bash " .. beez.char.quote(link_entry.script)
end

function M.index(config, root)
    local script = root .. "/" .. config.index_script
    local parts = {
        config.python_binary,
        beez.char.quote(script),
        beez.char.quote(config.build_tree_abs),
        beez.char.quote(config.index_lua_abs),
    }

    return table.concat(parts, " ")
end

function M.setup(config, root)
    local stamp = root .. "/" .. config.build_tree .. "/.gcc-objc-setup-ok"
    return table.concat({
        config.cc,
        "--version",
        "&&",
        "mkdir -p " .. beez.char.quote(config.bin_dir_abs),
        "&&",
        M.index(config, root),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.test(config, root)
    local report = root .. "/" .. config.reports_dir .. "/test/gcc-objc-" .. config.profile_name .. ".ok"
    local ctest_file = config.build_tree_abs .. "/CTestTestfile.cmake"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. config.reports_dir .. "/test"),
        "&&",
        "if [ -f " .. beez.char.quote(ctest_file) .. " ]; then",
        "cd " .. beez.char.quote(config.build_tree_abs),
        "&& ctest --output-on-failure;",
        "else",
        "echo " .. beez.char.quote(config.log_prefix_test .. " no CTestTestfile.cmake, skipping tests"),
        "; fi",
        "&&",
        "touch " .. beez.char.quote(report),
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
