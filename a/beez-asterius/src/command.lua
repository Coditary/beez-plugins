local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.asterius-setup-done"
end

local function ahc_options_args(cfg)
    if cfg.ahc_options == nil or cfg.ahc_options == "" then
        return {}
    end
    return { cfg.ahc_options }
end

function M.setup(cfg, root)
    local stamp = setup_stamp(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.build_tool == "cabal" then
        parts[#parts + 1] = cfg.ahc_cabal_binary
        parts[#parts + 1] = "new-update"
    else
        parts[#parts + 1] = cfg.ahc_link_binary
        parts[#parts + 1] = "--version"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch"
    parts[#parts + 1] = beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile_cabal_target(cfg, root, exe_name)
    local pseudo_exe = root .. "/" .. cfg.pseudo_exe_dir .. "/" .. exe_name
    local output_dir = root .. "/" .. cfg.wasm_dir .. "/" .. exe_name

    local parts = {
        cfg.ahc_dist_binary,
        "--input-exe",
        beez.char.quote(pseudo_exe),
        "--output-dir=" .. beez.char.quote(output_dir),
    }

    for _, arg in ipairs(ahc_options_args(cfg)) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.wasm_dir),
        beez.char.quote(root .. "/" .. cfg.pseudo_exe_dir),
        "&&",
    }

    if cfg.build_tool == "cabal" then
        parts[#parts + 1] = cfg.ahc_cabal_binary
        parts[#parts + 1] = "build"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.ahc_cabal_binary
        parts[#parts + 1] = "new-install"
        parts[#parts + 1] = "--installdir=" .. beez.char.quote(root .. "/" .. cfg.pseudo_exe_dir)
        parts[#parts + 1] = "--overwrite-policy=always"

        for _, arg in ipairs(ahc_options_args(cfg)) do
            parts[#parts + 1] = arg
        end

        for _, name in ipairs(cfg.executables) do
            parts[#parts + 1] = "&&"
            parts[#parts + 1] = M.compile_cabal_target(cfg, root, name)
        end
    else
        local output_dir = root .. "/" .. cfg.wasm_dir
        parts[#parts + 1] = cfg.ahc_link_binary
        parts[#parts + 1] = "--input-hs"
        parts[#parts + 1] = beez.char.quote(cfg.main_hs)
        parts[#parts + 1] = "--output-dir=" .. beez.char.quote(output_dir)

        for _, arg in ipairs(ahc_options_args(cfg)) do
            parts[#parts + 1] = arg
        end
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    local checks = {}

    for _, name in ipairs(cfg.executables) do
        local wasm_path = root .. "/" .. cfg.wasm_dir .. "/" .. name .. ".wasm"
        checks[#checks + 1] = "test -f " .. beez.char.quote(wasm_path)
    end

    if cfg.build_tool == "ahc" and cfg.main_hs ~= nil then
        local hs_name = cfg.main_hs:match("([^/]+)$") or cfg.package_name
        hs_name = hs_name:match("^(.+)%.hs$") or cfg.package_name
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. cfg.wasm_dir .. "/" .. hs_name .. ".wasm")
    end

    if cfg.build_tool == "cabal" then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.wasm_dir)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.wasm_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
    }

    if cfg.build_tool == "cabal" then
        parts[#parts + 1] = cfg.ahc_cabal_binary
        parts[#parts + 1] = "test"
    else
        parts[#parts + 1] = cfg.ahc_link_binary
        parts[#parts + 1] = "--input-hs"
        parts[#parts + 1] = beez.char.quote(cfg.main_hs)
        parts[#parts + 1] = "--output-dir=" .. beez.char.quote(root .. "/" .. cfg.wasm_dir)
        parts[#parts + 1] = "--run"
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

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
