local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function relative_path(cfg, path)
    if path == nil then
        return nil
    end

    if cfg.project_root == "." or cfg.project_root == "" then
        return path
    end

    local prefix = cfg.project_root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return path
end

local function quoted_project_file(cfg)
    if cfg.project_file == nil then
        return ""
    end

    return beez.char.quote(relative_path(cfg, cfg.project_file))
end

local function build_output_dir(cfg, root)
    return root .. "/" .. cfg.build_dir
end

local function ensure_build_dir(cfg, root)
    return "mkdir -p " .. beez.char.quote(build_output_dir(cfg, root))
end

local function restore_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.clojureclr-restored"
end

local function compile_output(cfg, root)
    return build_output_dir(cfg, root) .. "/" .. cfg.output_name .. ".dll"
end

local function resolve_main_namespace(cfg)
    if cfg.main_namespace ~= nil and cfg.main_namespace ~= "" then
        return cfg.main_namespace
    end

    if cfg.namespaces ~= nil and #cfg.namespaces > 0 then
        return cfg.namespaces[1]
    end

    return "user"
end

function M.restore(cfg, root)
    local stamp = restore_stamp(cfg, root)

    if cfg.toolchain == "dotnet" then
        local parts = {
            ensure_build_dir(cfg, root),
            "&&",
            project_cd(cfg, root),
            "&&",
            cfg.dotnet_binary,
            "restore",
            quoted_project_file(cfg),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }

        return table.concat(parts, " ")
    end

    if cfg.project_kind == "project.clj" then
        return table.concat({
            ensure_build_dir(cfg, root),
            "&&",
            project_cd(cfg, root),
            "&&",
            cfg.lein_binary,
            "deps",
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    if cfg.project_kind == "deps.edn" then
        return table.concat({
            ensure_build_dir(cfg, root),
            "&&",
            project_cd(cfg, root),
            "&&",
            cfg.clojure_binary,
            "-P",
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        ensure_build_dir(cfg, root),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build(cfg, root)
    if cfg.toolchain == "dotnet" then
        
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

return M.build_dotnet(cfg, root)
    end

    return M.build_clojure_compile(cfg, root)
end

function M.build_dotnet(cfg, root)
    local parts = {
        ensure_build_dir(cfg, root),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.dotnet_binary,
        "build",
        quoted_project_file(cfg),
        "-c",
        beez.char.quote(cfg.configuration),
        "--no-restore",
        "-o",
        beez.char.quote(build_output_dir(cfg, root)),
    }

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.build_clojure_compile(cfg, root)
    if cfg.project_kind == "project.clj" then
        return table.concat({
            ensure_build_dir(cfg, root),
            "&&",
            project_cd(cfg, root),
            "&&",
            cfg.lein_binary,
            "compile",
        }, " ")
    end

    local output = compile_output(cfg, root)
    local parts = {
        ensure_build_dir(cfg, root),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.clojure_compile_binary,
        "-d",
        beez.char.quote(build_output_dir(cfg, root)),
        "-o",
        beez.char.quote(output),
    }

    if cfg.project_kind == "deps.edn" then
        local main_ns = resolve_main_namespace(cfg)
        parts[#parts + 1] = beez.char.quote(main_ns)
    else
        for _, ns in ipairs(cfg.namespaces or {}) do
            parts[#parts + 1] = beez.char.quote(ns)
        end
    end

    for _, arg in ipairs(cfg.extra_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    if cfg.toolchain == "dotnet" then
        return "test -d " .. beez.char.quote(build_output_dir(cfg, root))
    end

    if cfg.project_kind == "project.clj" then
        return "test -d " .. beez.char.quote(build_output_dir(cfg, root))
    end

    return "test -f " .. beez.char.quote(compile_output(cfg, root))
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/clojureclr-" .. cfg.profile_name .. ".ok"

    if cfg.toolchain == "dotnet" then
        local parts = {
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            cfg.dotnet_binary,
            "test",
            quoted_project_file(cfg),
        }

        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end

        if cfg.test_filter ~= nil and cfg.test_filter ~= "" then
            parts[#parts + 1] = "--filter"
            parts[#parts + 1] = beez.char.quote(cfg.test_filter)
        end

        return table.concat(parts, " ")
    end

    if cfg.project_kind == "project.clj" then
        return table.concat({
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            cfg.lein_binary,
            "test",
        }, " ")
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "touch " .. beez.char.quote(report),
    }, " ")
end

return M
