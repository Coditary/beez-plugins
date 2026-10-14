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

local function deps_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.clojure-setup"
end

function M.deps(cfg, root)
    local stamp = deps_stamp(cfg, root)

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
        "command -v " .. cfg.clojure_binary,
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
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

    if cfg.project_kind == "deps.edn" then
        return table.concat({
            ensure_build_dir(cfg, root),
            "&&",
            project_cd(cfg, root),
            "&&",
            cfg.clojure_binary,
            "-M:" .. cfg.build_alias,
        }, " ")
    end

    local compile_cmds = {}
    for _, ns in ipairs(cfg.namespaces or {}) do
        compile_cmds[#compile_cmds + 1] = table.concat({
            project_cd(cfg, root),
            "&&",
            cfg.clojure_binary,
            "-M",
            "-e",
            beez.char.quote("(compile '" .. ns .. ")"),
        }, " ")
    end

    if #compile_cmds == 0 then
        return ensure_build_dir(cfg, root)
    end

    return table.concat({
        ensure_build_dir(cfg, root),
        "&&",
        table.concat(compile_cmds, " && "),
    }, " ")
end

function M.verify_artifacts(cfg, root)
    return "test -d " .. beez.char.quote(build_output_dir(cfg, root))
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/clojure-" .. cfg.profile_name .. ".ok"

    if cfg.project_kind == "project.clj" then
        local parts = {
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            cfg.lein_binary,
            "test",
        }

        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end

        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(report)
        return table.concat(parts, " ")
    end

    if cfg.project_kind == "deps.edn" then
        local parts = {
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            cfg.clojure_binary,
            "-M:" .. cfg.test_alias,
        }

        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end

        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(report)
        return table.concat(parts, " ")
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "touch " .. beez.char.quote(report),
    }, " ")
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
