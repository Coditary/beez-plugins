local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function build_output_dir(cfg, root)
    return root .. "/" .. cfg.build_dir
end

local function ensure_build_dir(cfg, root)
    return "mkdir -p " .. beez.char.quote(build_output_dir(cfg, root))
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.hhvm-setup"
end

local function checked_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.hhvm-checked"
end

function M.setup(cfg, root)
    local stamp = setup_stamp(cfg, root)
    local parts = {
        ensure_build_dir(cfg, root),
        "&&",
        project_cd(cfg, root),
    }

    if cfg.has_composer then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.composer_binary
        parts[#parts + 1] = "install"
        parts[#parts + 1] = "--no-interaction"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.hhvm_autoload_binary
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.typecheck(cfg, root)
    local stamp = checked_stamp(cfg, root)
    local parts = {
        ensure_build_dir(cfg, root),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.hhvm_binary,
        "--check",
    }

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    for _, entry in ipairs(cfg.entry_points) do
        parts[#parts + 1] = beez.char.quote(entry)
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    local checks = {
        "test -f " .. beez.char.quote(checked_stamp(cfg, root)),
    }

    if cfg.has_composer then
        checks[#checks + 1] = "test -f vendor/autoload.hh"
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/hhvm-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.hhvm_binary,
    }

    if cfg.has_composer then
        parts[#parts + 1] = "vendor/bin/" .. cfg.phpunit_binary
    else
        parts[#parts + 1] = cfg.phpunit_binary
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

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
