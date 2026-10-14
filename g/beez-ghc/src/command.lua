local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function ghc_options_arg(cfg)
    if cfg.ghc_options == nil or cfg.ghc_options == "" then
        return ""
    end
    return "--ghc-options=" .. beez.char.quote(cfg.ghc_options)
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.ghc-setup-done"
end

function M.setup(cfg, root)
    local stamp = setup_stamp(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.build_tool == "stack" then
        parts[#parts + 1] = cfg.stack_binary
        parts[#parts + 1] = "setup"
    elseif cfg.build_tool == "cabal" then
        parts[#parts + 1] = cfg.cabal_binary
        parts[#parts + 1] = "update"
    else
        parts[#parts + 1] = cfg.ghc_binary
        parts[#parts + 1] = "--version"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch"
    parts[#parts + 1] = beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
    }

    if cfg.build_tool == "stack" then
        parts[#parts + 1] = cfg.stack_binary
        parts[#parts + 1] = "build"
        local opts = ghc_options_arg(cfg)
        if opts ~= "" then
            parts[#parts + 1] = opts
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.stack_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "--local-bin-path"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.bin_dir)
    elseif cfg.build_tool == "cabal" then
        parts[#parts + 1] = cfg.cabal_binary
        parts[#parts + 1] = "build"
        local opts = ghc_options_arg(cfg)
        if opts ~= "" then
            parts[#parts + 1] = opts
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.cabal_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "--installdir=" .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        parts[#parts + 1] = "--overwrite-policy=always"
        parts[#parts + 1] = "--install-method=copy"
        if opts ~= "" then
            parts[#parts + 1] = opts
        end
    else
        local output = root .. "/" .. cfg.bin_dir .. "/" .. cfg.package_name
        parts[#parts + 1] = cfg.ghc_binary
        if cfg.ghc_options ~= nil and cfg.ghc_options ~= "" then
            parts[#parts + 1] = cfg.ghc_options
        end
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(output)
        parts[#parts + 1] = beez.char.quote(cfg.main_hs)
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    local checks = {}

    for _, name in ipairs(cfg.executables) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. cfg.bin_dir .. "/" .. name)
    end

    if cfg.build_tool == "ghc" and cfg.main_hs ~= nil then
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. cfg.bin_dir .. "/" .. cfg.package_name)
    end

    if cfg.build_tool == "cabal" then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.dist_dir)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
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

    if cfg.build_tool == "stack" then
        parts[#parts + 1] = cfg.stack_binary
        parts[#parts + 1] = "test"
    elseif cfg.build_tool == "cabal" then
        parts[#parts + 1] = cfg.cabal_binary
        parts[#parts + 1] = "test"
    else
        parts[#parts + 1] = cfg.ghc_binary
        parts[#parts + 1] = "--make"
        parts[#parts + 1] = "-o"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.build_dir .. "/test-runner")
        parts[#parts + 1] = beez.char.quote(cfg.main_hs)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.build_dir .. "/test-runner")
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
