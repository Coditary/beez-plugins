local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

local function compile_flags(cfg)
    local flags = {}
    if cfg.optimize then
        flags[#flags + 1] = "-ot"
    end
    if cfg.debug_info then
        flags[#flags + 1] = "-d2"
    end
    if cfg.watcom_flags ~= nil then
        for _, flag in ipairs(cfg.watcom_flags) do
            flags[#flags + 1] = flag
        end
    end
    return table.concat(flags, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.watcom-fortran-setup-ok"
    return table.concat({
        cfg.wfc_binary,
        "-?",
        "||",
        cfg.wfc_binary,
        "/?",
        "||",
        "true",
        "&&",
        cfg.wfl_binary,
        "-?",
        "||",
        cfg.wfl_binary,
        "/?",
        "||",
        "true",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_plain_target(cfg, root, target)
    local flags = compile_flags(cfg)
    local sources = {}
    for _, source_path in ipairs(target.sources) do
        sources[#sources + 1] = beez.char.quote(root .. "/" .. source_path)
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        cfg.wfl_binary,
    }

    if flags ~= "" then
        parts[#parts + 1] = flags
    end

    parts[#parts + 1] = "-fo=" .. beez.char.quote(root .. "/" .. cfg.obj_dir)
    parts[#parts + 1] = "-fe=" .. beez.char.quote(root .. "/" .. target.output)
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
        "-DCMAKE_Fortran_COMPILER=" .. cfg.wfc_binary,
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
        "make FC=" .. cfg.wfc_binary,
        "FFLAGS=" .. beez.char.quote(flags),
    }, " ")
end

function M.build_target(cfg, root, target)
    if target.kind == "cmake" then
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

function M.run_target(cfg, root, target)
    local exe = root .. "/" .. target.output
    if cfg.run_binary ~= nil and cfg.run_binary ~= "" then
        return cfg.run_binary .. " " .. beez.char.quote(exe)
    end
    return beez.char.quote(exe)
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/watcom-fortran-" .. cfg.profile_name .. ".ok"

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
        commands[#commands + 1] = M.run_target(cfg, root, target)
    end

    commands[#commands + 1] = "&&"
    commands[#commands + 1] = "touch " .. beez.char.quote(report)

    return table.concat(commands, " ")
end

return M
