local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function flang_select(cfg)
    return table.concat({
        "FLANG=$(command -v " .. beez.char.quote(cfg.flang_binary) .. " 2>/dev/null",
        "|| command -v " .. beez.char.quote(cfg.flang_binary_fallback) .. ")",
    }, " ")
end

local function exe_dir_for_target(cfg, root, target)
    local output_path = root .. "/" .. target.output
    return output_path:match("^(.*)/[^/]+$") or (root .. "/" .. cfg.bin_dir)
end

function M.prepare(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.flang-prepared-" .. cfg.profile_name

    return table.concat({
        flang_select(cfg),
        "&& test -n \"$FLANG\"",
        "&& mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&& mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&& \"$FLANG\" --version",
        "&& touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_cmake(cfg, root)
    local cmake_build = root .. "/" .. cfg.cmake_dir .. "/" .. cfg.profile_name
    local bin_dir = root .. "/" .. cfg.bin_dir
    local parallel = ""
    if cfg.parallelism ~= nil and cfg.parallelism ~= "" and cfg.parallelism ~= "0" then
        parallel = " --parallel " .. beez.char.quote(cfg.parallelism)
    end

    return table.concat({
        flang_select(cfg),
        "&& test -n \"$FLANG\"",
        "&& mkdir -p " .. beez.char.quote(cmake_build),
        "&& mkdir -p " .. beez.char.quote(bin_dir),
        "&& " .. project_cd(cfg, root),
        "&& cmake -S . -B " .. beez.char.quote(cmake_build),
        "-DCMAKE_BUILD_TYPE=" .. cfg.cmake_build_type,
        "-DCMAKE_Fortran_COMPILER=\"$FLANG\"",
        "-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=" .. beez.char.quote(bin_dir),
        "&& cmake --build " .. beez.char.quote(cmake_build) .. parallel,
    }, " ")
end

function M.compile_make(cfg, root)
    local parallel = ""
    if cfg.parallelism ~= nil and cfg.parallelism ~= "" and cfg.parallelism ~= "0" then
        parallel = " -j" .. cfg.parallelism
    else
        parallel = " -j"
    end

    return table.concat({
        flang_select(cfg),
        "&& test -n \"$FLANG\"",
        "&& mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&& " .. project_cd(cfg, root),
        "&& make FC=\"$FLANG\" F77=\"$FLANG\"" .. parallel,
    }, " ")
end

function M.compile_direct_target(cfg, root, target)
    local exe_dir = exe_dir_for_target(cfg, root, target)
    local output_path = root .. "/" .. target.output

    local parts = {
        flang_select(cfg),
        "&& test -n \"$FLANG\"",
        "&& mkdir -p " .. beez.char.quote(exe_dir),
        "&& " .. project_cd(cfg, root),
        "&& \"$FLANG\"",
    }

    if cfg.optimize ~= nil and cfg.optimize ~= "" then
        parts[#parts + 1] = cfg.optimize
    end

    if cfg.debug_flags ~= nil and cfg.debug_flags ~= "" then
        parts[#parts + 1] = cfg.debug_flags
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output_path)
    parts[#parts + 1] = target.source

    return table.concat(parts, " ")
end

function M.compile_target(cfg, root, target)
    local build_system = target.build_system or cfg.build_system
    if build_system == "cmake" then
        
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

return M.compile_cmake(cfg, root)
    end
    if build_system == "make" then
        return M.compile_make(cfg, root)
    end
    return M.compile_direct_target(cfg, root, target)
end

function M.compile_all(cfg, root)
    local commands = {}
    local seen = {}

    for _, target in ipairs(cfg.targets) do
        local build_system = target.build_system or cfg.build_system
        if build_system == "cmake" or build_system == "make" then
            if not seen[build_system] then
                seen[build_system] = true
                commands[#commands + 1] = M.compile_target(cfg, root, target)
            end
        else
            commands[#commands + 1] = M.compile_target(cfg, root, target)
        end
    end

    return table.concat(commands, " && ")
end

function M.verify_binaries(cfg, root)
    local checks = {}
    local seen = {}

    for _, target in ipairs(cfg.targets) do
        local build_system = target.build_system or cfg.build_system
        if build_system == "make" and not seen.make then
            seen.make = true
            checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        elseif build_system ~= "make" then
            checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
        end
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/flang-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&& mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
    }

    if cfg.test_runner ~= nil and cfg.test_runner.kind == "ctest" then
        local cmake_build = root .. "/" .. cfg.cmake_dir .. "/" .. cfg.profile_name
        parts[#parts + 1] = "test -d " .. beez.char.quote(cmake_build)
        parts[#parts + 1] = "&& ctest --test-dir " .. beez.char.quote(cmake_build) .. " --output-on-failure"
    elseif cfg.test_runner ~= nil and cfg.test_runner.kind == "program" then
        local runner_stem = cfg.test_runner.source:match("([^/]+)$"):match("^(.+)%.[^%.]+$")
            or cfg.test_runner.source:match("([^/]+)$")
        local runner_output = root .. "/" .. cfg.bin_dir .. "/" .. runner_stem

        parts[#parts + 1] = flang_select(cfg)
        parts[#parts + 1] = "&& test -n \"$FLANG\""
        parts[#parts + 1] = "&& " .. project_cd(cfg, root)
        parts[#parts + 1] = "&& \"$FLANG\" -o " .. beez.char.quote(runner_output)
        parts[#parts + 1] = cfg.test_runner.source
        parts[#parts + 1] = "&& " .. beez.char.quote(runner_output)
    else
        parts[#parts + 1] = flang_select(cfg)
        parts[#parts + 1] = "&& test -n \"$FLANG\""
        parts[#parts + 1] = "&& \"$FLANG\" --version"
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&& touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

return M
