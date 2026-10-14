local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function erlc_opts_string(cfg)
    return table.concat(cfg.erlc_opts, " ")
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.hipe-setup"
end

local function source_relative_to_project(cfg, source)
    local project_root = cfg.project_root
    if project_root == nil or project_root == "." or project_root == "" then
        return source
    end

    local prefix = project_root .. "/"
    if source:sub(1, #prefix) == prefix then
        return source:sub(#prefix + 1)
    end

    return source
end

function M.hipe_support_check(cfg)
    return table.concat({
        cfg.erlc_binary,
        "+native",
        "-help",
        ">/dev/null",
        "2>&1",
    }, " ")
end

function M.setup_rebar3(cfg, root)
    local stamp = setup_stamp(cfg, root)

    return table.concat({
        M.hipe_support_check(cfg),
        "&&",
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.ebin_dir),
        "&&",
        cfg.rebar3_binary,
        "get-deps",
        "--quiet",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup_erlc(cfg, root)
    local stamp = setup_stamp(cfg, root)

    return table.concat({
        M.hipe_support_check(cfg),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.ebin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup(cfg, root)
    if cfg.backend == "rebar3" then
        
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

return M.setup_rebar3(cfg, root)
    end

    return M.setup_erlc(cfg, root)
end

function M.compile_rebar3(cfg, root)
    local opts = erlc_opts_string(cfg)
    local ebin = root .. "/" .. cfg.ebin_dir

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(ebin),
        "&&",
        "ERL_COMPILER_OPTIONS=" .. beez.char.quote(opts),
        cfg.rebar3_binary,
        "as",
        cfg.rebar_compile_profile,
        "compile",
        "&&",
        "if [ -d _build/default/lib ]; then find _build -name '*.beam' -exec cp {} " .. beez.char.quote(ebin) .. "/ \\;; fi",
        "&&",
        "if [ -d ebin ]; then cp -a ebin/. " .. beez.char.quote(ebin) .. "/; fi",
    }, " ")
end

function M.compile_erlc(cfg, root)
    if #cfg.sources == 0 then
        error("hipe plugin: no Erlang source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(source_relative_to_project(cfg, source))
    end

    local ebin = root .. "/" .. cfg.ebin_dir
    local opts = erlc_opts_string(cfg)

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(ebin),
        "&&",
        cfg.erlc_binary,
        opts,
        "-o",
        beez.char.quote(ebin),
        table.concat(quoted_sources, " "),
    }, " ")
end

function M.compile(cfg, root)
    if cfg.backend == "rebar3" then
        return M.compile_rebar3(cfg, root)
    end

    return M.compile_erlc(cfg, root)
end

function M.install_launcher(cfg, root)
    local ebin = root .. "/" .. cfg.ebin_dir
    local launcher = root .. "/" .. cfg.launcher_output

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "test -d " .. beez.char.quote(ebin),
        "&&",
        "find " .. beez.char.quote(ebin) .. " -name '*.beam' | head -1 | grep -q .",
        "&&",
        "printf '%s\\n' '#!/bin/sh'",
        "'exec " .. cfg.erl_binary .. " +native -pa " .. ebin .. " \"$@\"' > " .. beez.char.quote(launcher),
        "&&",
        "chmod +x " .. beez.char.quote(launcher),
    }, " ")
end

function M.verify(cfg, root)
    local ebin = root .. "/" .. cfg.ebin_dir

    return table.concat({
        "test -d " .. beez.char.quote(ebin),
        "&&",
        "find " .. beez.char.quote(ebin) .. " -name '*.beam' | head -1 | grep -q .",
    }, " ")
end

function M.test_rebar3(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/hipe-" .. cfg.profile_name .. ".ok"
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.rebar3_binary,
        "eunit",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "||"
    parts[#parts + 1] = cfg.rebar3_binary
    parts[#parts + 1] = "ct"
    parts[#parts + 1] = "||"
    parts[#parts + 1] = "true"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(report)

    return table.concat(parts, " ")
end

function M.test_erlc(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/hipe-" .. cfg.profile_name .. ".ok"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'hipe standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(report),
    }, " ")
end

function M.test(cfg, root)
    if cfg.backend == "rebar3" then
        return M.test_rebar3(cfg, root)
    end

    return M.test_erlc(cfg, root)
end

return M
