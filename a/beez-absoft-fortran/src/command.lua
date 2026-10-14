local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

local function compiler_for_source(cfg, source_path)
    if source_path:match("%.f$") and not source_path:match("%.f90$") then
        return cfg.f77_binary
    end
    return cfg.f90_binary
end

local function compiler_for_target(cfg, target)
    local compiler = cfg.f90_binary
    for _, source_path in ipairs(target.sources) do
        if compiler_for_source(cfg, source_path) == cfg.f77_binary then
            return cfg.f77_binary
        end
    end
    return compiler
end

local function compile_flags(cfg)
    local flags = {}
    if cfg.optimize then
        flags[#flags + 1] = "-O3"
    end
    if cfg.debug_info then
        flags[#flags + 1] = "-g"
    end
    if cfg.absoft_flags ~= nil then
        for _, flag in ipairs(cfg.absoft_flags) do
            flags[#flags + 1] = flag
        end
    end
    return table.concat(flags, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.absoft-setup-ok"
    return table.concat({
        cfg.f90_binary,
        "-V",
        "||",
        cfg.f90_binary,
        "--version",
        "||",
        "true",
        "&&",
        cfg.f77_binary,
        "-V",
        "||",
        cfg.f77_binary,
        "--version",
        "||",
        "true",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_plain_target(cfg, root, target)
    local flags = compile_flags(cfg)
    local compiler = compiler_for_target(cfg, target)
    local sources = {}
    for _, source_path in ipairs(target.sources) do
        sources[#sources + 1] = beez.char.quote(root .. "/" .. source_path)
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        compiler,
    }

    if flags ~= "" then
        parts[#parts + 1] = flags
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. target.output)
    for _, source in ipairs(sources) do
        parts[#parts + 1] = source
    end

    return table.concat(parts, " ")
end

function M.build_cmake_target(cfg, root, target)
    local dir = project_dir(cfg, root)
    local cmake_dir = root .. "/" .. cfg.build_dir .. "/cmake"
    local bin_dir = root .. "/" .. cfg.bin_dir

    return table.concat({
        "mkdir -p " .. beez.char.quote(cmake_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(bin_dir),
        "&&",
        "cd " .. beez.char.quote(dir),
        "&&",
        "cmake -S . -B " .. beez.char.quote(cmake_dir),
        "-DCMAKE_Fortran_COMPILER=" .. cfg.f90_binary,
        "-DCMAKE_BUILD_TYPE=Release",
        "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=" .. beez.char.quote(bin_dir),
        "&&",
        "cmake --build " .. beez.char.quote(cmake_dir),
        "-j" .. (cfg.parallelism or "4"),
    }, " ")
end

function M.build_makefile_target(cfg, root, target)
    local dir = project_dir(cfg, root)
    local flags = compile_flags(cfg)

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "cd " .. beez.char.quote(dir),
        "&&",
        "make FC=" .. cfg.f90_binary,
        "F77=" .. cfg.f77_binary,
        "F90=" .. cfg.f90_binary,
        "FFLAGS=" .. beez.char.quote(flags),
    }, " ")
end

function M.build_target(cfg, root, target)
    if target.kind == "cmake" then
        
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

return M.build_cmake_target(cfg, root, target)
    end
    if target.kind == "makefile" then
        return M.build_makefile_target(cfg, root, target)
    end
    return M.build_plain_target(cfg, root, target)
end

function M.build_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/absoft-" .. cfg.profile_name .. ".ok"

    if #cfg.test_targets == 0 then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(report),
        }, " ")
    end

    local commands = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    for _, target in ipairs(cfg.test_targets) do
        commands[#commands + 1] = "&&"
        commands[#commands + 1] = M.build_plain_target(cfg, root, target)
        commands[#commands + 1] = "&&"
        commands[#commands + 1] = beez.char.quote(root .. "/" .. target.output)
    end

    commands[#commands + 1] = "&&"
    commands[#commands + 1] = "touch " .. beez.char.quote(report)

    return table.concat(commands, " ")
end

return M
