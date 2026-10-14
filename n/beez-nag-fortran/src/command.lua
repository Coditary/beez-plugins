local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function exe_dir_for_target(cfg, root, target)
    local output_path = root .. "/" .. target.output
    return output_path:match("^(.*)/[^/]+$") or (root .. "/" .. cfg.bin_dir)
end

local function parallel_flag(cfg)
    if cfg.parallelism ~= nil and cfg.parallelism ~= "" and cfg.parallelism ~= "0" then
        return "-j" .. beez.char.quote(cfg.parallelism)
    end
    return ""
end

function M.prepare(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.nag-prepared"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.nagfor_binary,
        "-V",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_target(cfg, root, target)
    local exe_dir = exe_dir_for_target(cfg, root, target)
    local output_path = root .. "/" .. target.output

    local parts = {
        "mkdir -p " .. beez.char.quote(exe_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.nagfor_binary,
    }

    if cfg.fortran_std ~= nil and cfg.fortran_std ~= "" then
        parts[#parts + 1] = cfg.fortran_std
    end

    if cfg.optimize ~= nil and cfg.optimize ~= "" then
        parts[#parts + 1] = cfg.optimize
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output_path)
    parts[#parts + 1] = target.source

    return table.concat(parts, " ")
end

function M.compile_sources(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.cmake_configure(cfg, root)
    local cmake_build = root .. "/" .. cfg.cmake_dir
    local build_type = cfg.build_mode == "debug" and "Debug" or "Release"

    return table.concat({
        "mkdir -p " .. beez.char.quote(cmake_build),
        "&&",
        project_cd(cfg, root),
        "&&",
        "cmake",
        "-S",
        beez.char.quote("."),
        "-B",
        beez.char.quote(cmake_build),
        "-DCMAKE_Fortran_COMPILER=" .. beez.char.quote(cfg.nagfor_binary),
        "-DCMAKE_BUILD_TYPE=" .. beez.char.quote(build_type),
        "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=" .. beez.char.quote(root .. "/" .. cfg.bin_dir),
    }, " ")
end

function M.cmake_build(cfg, root)
    local cmake_build = root .. "/" .. cfg.cmake_dir
    local jflag = parallel_flag(cfg)

    local parts = {
        project_cd(cfg, root),
        "&&",
        "cmake",
        "--build",
        beez.char.quote(cmake_build),
        "--config",
        cfg.build_mode == "debug" and "Debug" or "Release",
    }

    if jflag ~= "" then
        parts[#parts + 1] = jflag
    end

    return table.concat(parts, " ")
end

function M.makefile_build(cfg, root)
    local jflag = parallel_flag(cfg)

    local parts = {
        project_cd(cfg, root),
        "&&",
        "make",
        "FC=" .. beez.char.quote(cfg.nagfor_binary),
        "F77=" .. beez.char.quote(cfg.nagfor_binary),
        "F90=" .. beez.char.quote(cfg.nagfor_binary),
    }

    if jflag ~= "" then
        parts[#parts + 1] = jflag
    end

    return table.concat(parts, " ")
end

function M.compile_all(cfg, root)
    if cfg.build_system == "cmake" then
        
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

return M.cmake_configure(cfg, root) .. " && " .. M.cmake_build(cfg, root)
    end

    if cfg.build_system == "makefile" then
        return M.makefile_build(cfg, root)
    end

    return M.compile_sources(cfg, root)
end

function M.verify_binaries(cfg, root)
    if cfg.build_system == "cmake" then
        return "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    if cfg.build_system == "makefile" then
        return "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
            .. " || test -d " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    end

    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/nag-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
    }

    if cfg.build_system == "cmake" then
        local cmake_build = root .. "/" .. cfg.cmake_dir
        parts[#parts + 1] = project_cd(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "ctest --test-dir " .. beez.char.quote(cmake_build) .. " --output-on-failure"
    elseif cfg.build_system == "makefile" then
        parts[#parts + 1] = project_cd(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "make test FC=" .. beez.char.quote(cfg.nagfor_binary)
            .. " F77=" .. beez.char.quote(cfg.nagfor_binary)
            .. " F90=" .. beez.char.quote(cfg.nagfor_binary)
            .. " || " .. cfg.nagfor_binary .. " -V"
    elseif cfg.test_runner ~= nil then
        local runner_stem = cfg.test_runner:match("([^/]+)$"):match("^(.+)%.[^%.]+$")
            or cfg.test_runner:match("([^/]+)$")
        local runner_output = root .. "/" .. cfg.bin_dir .. "/" .. runner_stem

        parts[#parts + 1] = project_cd(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.nagfor_binary
        if cfg.fortran_std ~= nil and cfg.fortran_std ~= "" then
            parts[#parts + 1] = cfg.fortran_std
        end
        if cfg.optimize ~= nil and cfg.optimize ~= "" then
            parts[#parts + 1] = cfg.optimize
        end
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(runner_output)
        parts[#parts + 1] = cfg.test_runner
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = beez.char.quote(runner_output)
    else
        parts[#parts + 1] = cfg.nagfor_binary
        parts[#parts + 1] = "-V"
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

return M
