local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_cmake(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.cmake-setup"
    local cmake_dir = root .. "/" .. cfg.cmake_build_dir
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.cmake_binary,
        "--version",
        "&&",
        "test -f " .. beez.char.quote(cfg.entry_source),
        "&&",
        cfg.cmake_binary,
        "-S",
        beez.char.quote(cfg.source_dir),
        "-B",
        beez.char.quote(cmake_dir),
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "-DCMAKE_BUILD_TYPE=Debug"
    else
        parts[#parts + 1] = "-DCMAKE_BUILD_TYPE=Release"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local cmake_dir = root .. "/" .. cfg.cmake_build_dir
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.cmake_binary,
        "--build",
        beez.char.quote(cmake_dir),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/cmake-" .. cfg.profile_name .. ".ok"
    local cmake_dir = root .. "/" .. cfg.cmake_build_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.cmake_binary,
        "--test-dir",
        beez.char.quote(cmake_dir),
        "--output-on-failure",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end



return M
