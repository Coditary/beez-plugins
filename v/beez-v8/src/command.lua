local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function runtime_binary(cfg)
    if cfg.v8_engine == "d8" then
        return cfg.d8_binary
    end
    return cfg.node_binary
end

local function source_relative(cfg, source)
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        local prefix = cfg.project_root .. "/"
        if source:sub(1, #prefix) == prefix then
            return source:sub(#prefix + 1)
        end
    end

    return source
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.v8-setup"
    local runtime = runtime_binary(cfg)

    local parts = {
        "command -v " .. runtime,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
    }

    if cfg.has_package_json then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = project_cd(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.npm_binary
        parts[#parts + 1] = "install"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.check_source(cfg, source)
    local runtime = runtime_binary(cfg)
    local rel = source_relative(cfg, source)

    if cfg.v8_engine == "d8" then
        return table.concat({
            runtime,
            "--check",
            beez.char.quote(rel),
        }, " ")
    end

    return table.concat({
        cfg.node_binary,
        "--check",
        beez.char.quote(rel),
    }, " ")
end

function M.copy_source(cfg, root, source)
    local dist = root .. "/" .. cfg.dist_dir
    local rel = source_relative(cfg, source)

    local dest = dist .. "/" .. rel
    local dest_dir = dest:match("^(.*)/[^/]+$") or dist

    return table.concat({
        "mkdir -p " .. beez.char.quote(dest_dir),
        "&&",
        "cp " .. beez.char.quote(rel) .. " " .. beez.char.quote(dest),
    }, " ")
end

function M.compile(cfg, root)
    local dist = root .. "/" .. cfg.dist_dir
    local parts = {
        "mkdir -p " .. beez.char.quote(dist),
        "&&",
        project_cd(cfg, root),
    }

    for i, source in ipairs(cfg.sources) do
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = M.check_source(cfg, source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = M.copy_source(cfg, root, source)
    end

    if cfg.compile_args ~= nil and cfg.compile_args ~= "" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.compile_args
    end

    return table.concat(parts, " ")
end

function M.verify_dist(cfg, root)
    local dist = root .. "/" .. cfg.dist_dir
    return "test -d " .. beez.char.quote(dist) .. " && test -n \"$(ls -A " .. beez.char.quote(dist) .. " 2>/dev/null)\""
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/v8-" .. cfg.profile_name .. ".ok"

    if not cfg.has_package_json then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "touch " .. beez.char.quote(ok_file),
        }, " ")
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.npm_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = "--"
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
