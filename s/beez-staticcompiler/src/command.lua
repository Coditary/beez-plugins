local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function julia_threads_prefix(cfg)
    if cfg.parallelism == nil or cfg.parallelism == "" or cfg.parallelism == "0" then
        return ""
    end

    return "export JULIA_CPU_THREADS=" .. beez.char.quote(cfg.parallelism) .. " && "
end

local function cflags_line(cfg)
    if cfg.cflags == nil or cfg.cflags == "" then
        return ""
    end

    return "cflags=" .. beez.char.quote(cfg.cflags) .. ","
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.staticcompiler-setup"

    return table.concat({
        julia_threads_prefix(cfg),
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        cfg.julia_binary,
        "--project=.",
        "-e",
        beez.char.quote("using Pkg; Pkg.instantiate(); using StaticCompiler"),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_executable_script(cfg, root)
    local bin_dir = root .. "/" .. cfg.bin_dir
    local lines = {
        "using StaticCompiler",
        "include(" .. beez.char.quote(cfg.entry_script_rel) .. ")",
        "compile_executable(",
        "    " .. cfg.entry_function .. ",",
        "    " .. cfg.arg_types .. ",",
        "    " .. beez.char.quote(bin_dir) .. ",",
        "    " .. beez.char.quote(cfg.output_name) .. ";",
    }

    local cflags = cflags_line(cfg)
    if cflags ~= "" then
        lines[#lines + 1] = "    " .. cflags
    end

    lines[#lines + 1] = ")"
    return table.concat(lines, "\n")
end

function M.compile_shlib_script(cfg, root)
    local bin_dir = root .. "/" .. cfg.bin_dir
    local lines = {
        "using StaticCompiler",
        "include(" .. beez.char.quote(cfg.entry_script_rel) .. ")",
        "compile_shlib(",
        "    " .. cfg.entry_function .. ",",
        "    " .. cfg.arg_types .. ",",
        "    " .. beez.char.quote(bin_dir) .. ",",
        "    " .. beez.char.quote(cfg.shlib_basename) .. ";",
    }

    local cflags = cflags_line(cfg)
    if cflags ~= "" then
        lines[#lines + 1] = "    " .. cflags
    end

    lines[#lines + 1] = ")"
    return table.concat(lines, "\n")
end

function M.compile_with_heredoc(cfg, root, script_body)
    local header = table.concat({
        julia_threads_prefix(cfg),
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.julia_binary,
    }, " ")

    if cfg.julia_flags ~= nil and cfg.julia_flags ~= "" then
        header = header .. " " .. cfg.julia_flags
    end

    header = header .. " --project=."

    return header .. "\n<<'JULIA_EOF'\n" .. script_body .. "\nJULIA_EOF"
end

function M.compile(cfg, root)
    local script_body
    if cfg.compile_mode == "compile_shlib" then
        script_body = M.compile_shlib_script(cfg, root)
    else
        script_body = M.compile_executable_script(cfg, root)
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

return M.compile_with_heredoc(cfg, root, script_body)
end

function M.verify_executable(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "test -f " .. beez.char.quote(output),
        "&&",
        "test -x " .. beez.char.quote(output),
    }, " ")
end

function M.verify_shlib(cfg, root)
    local bin_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)
    return table.concat({
        "test -d " .. bin_dir,
        "&&",
        "find " .. bin_dir,
        "-maxdepth 1 -name '" .. cfg.shlib_basename .. ".*' -type f | grep -q .",
    }, " ")
end

function M.verify(cfg, root)
    if cfg.compile_mode == "compile_shlib" then
        return M.verify_shlib(cfg, root)
    end

    return M.verify_executable(cfg, root)
end

function M.test(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/staticcompiler-" .. cfg.profile_name .. ".ok"
    local parts = {
        julia_threads_prefix(cfg),
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.julia_binary,
        "--project=.",
        "-e",
        beez.char.quote("using Pkg; Pkg.test()"),
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

return M
