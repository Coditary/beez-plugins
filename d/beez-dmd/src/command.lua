local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.dmd-setup-ok"
end

local function bin_dir_abs(cfg, root)
    return root .. "/" .. cfg.bin_dir
end

local function primary_output_abs(cfg, root)
    return root .. "/" .. cfg.primary_output
end

function M.fetch(cfg, root)
    local stamp = setup_stamp(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        project_cd(cfg, root),
    }

    if cfg.project_type == "dub" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.dub_binary
        parts[#parts + 1] = "fetch"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch"
    parts[#parts + 1] = beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.build(cfg, root)
    local out_dir = bin_dir_abs(cfg, root)
    local output = primary_output_abs(cfg, root)

    if cfg.project_type == "dub" then
        local parts = {
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(out_dir),
            "&&",
            cfg.dub_binary,
            "build",
            "--compiler=" .. cfg.dmd_binary,
            "-b=" .. cfg.dub_build,
            "-od=" .. beez.char.quote(out_dir),
        }

        return table.concat(parts, " ")
    end

    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(out_dir),
        "&&",
        cfg.dmd_binary,
    }

    for _, flag in ipairs(cfg.dmd_flags) do
        parts[#parts + 1] = flag
    end

    parts[#parts + 1] = "-of=" .. beez.char.quote(output)

    for _, source in ipairs(cfg.sources) do
        parts[#parts + 1] = beez.char.quote(source)
    end

    return table.concat(parts, " ")
end

function M.verify_binary(cfg, root)
    local output = primary_output_abs(cfg, root)
    return "test -f " .. beez.char.quote(output)
end

function M.test(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
    }

    if cfg.project_type == "dub" then
        parts[#parts + 1] = cfg.dub_binary
        parts[#parts + 1] = "test"
        parts[#parts + 1] = "--compiler=" .. cfg.dmd_binary
    else
        local output = primary_output_abs(cfg, root)
        local unittest_output = output .. "-unittest"

        parts[#parts + 1] = cfg.dmd_binary
        parts[#parts + 1] = "-unittest"
        parts[#parts + 1] = "-of=" .. beez.char.quote(unittest_output)

        for _, source in ipairs(cfg.sources) do
            parts[#parts + 1] = beez.char.quote(source)
        end

        parts[#parts + 1] = "&&"
        parts[#parts + 1] = beez.char.quote(unittest_output)
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
