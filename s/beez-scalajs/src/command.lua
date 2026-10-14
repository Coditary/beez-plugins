local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function sbt_invocation(cfg)
    return cfg.sbt_binary .. " -batch"
end

local function copy_js_artifacts(root, cfg)
    local js_dir = beez.char.quote(root .. "/" .. cfg.js_dir)
    local bin_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)

    return table.concat({
        "if [ -d target ]; then",
        "find target -type f -name '*.js' -exec cp -a {} " .. js_dir .. "/ \\;;",
        "fi",
        "&&",
        "if [ -d target ]; then",
        "find target -type f -name '*.js.map' -exec cp -a {} " .. js_dir .. "/ \\;;",
        "fi",
        "&&",
        "if [ -d target ]; then",
        "find target -type d -name 'fastopt' -o -type d -name 'fullopt' | while read -r dir; do",
        "cp -a \"$dir\"/. " .. bin_dir .. "/;",
        "done;",
        "fi",
    }, " ")
end

function M.setup_sbt(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.scalajs-setup"
    local sbt = sbt_invocation(cfg)

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        sbt,
        "update",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup_scalajs(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.scalajs-setup"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup(cfg, root)
    if cfg.backend == "sbt" then
        
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

return M.setup_sbt(cfg, root)
    end

    return M.setup_scalajs(cfg, root)
end

function M.compile_sbt(cfg, root)
    local sbt = sbt_invocation(cfg)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        sbt,
        cfg.sbt_compile_task,
        "&&",
        copy_js_artifacts(root, cfg),
    }

    return table.concat(parts, " ")
end

function M.compile_scalajs(cfg, root)
    if #cfg.sources == 0 then
        error("scalajs plugin: no Scala source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(root .. "/" .. source)
    end

    local output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        cfg.scalajs_binary,
        table.concat(quoted_sources, " "),
        "-output",
        beez.char.quote(output),
    }

    for _, arg in ipairs(cfg.scala_args) do
        parts[#parts + 1] = arg
    end

    if cfg.source_map then
        parts[#parts + 1] = "-sourcemap"
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    if cfg.backend == "sbt" then
        return M.compile_sbt(cfg, root)
    end

    return M.compile_scalajs(cfg, root)
end

function M.verify_sbt(cfg, root)
    local checks = {
        "test -d " .. beez.char.quote(root .. "/" .. cfg.js_dir),
    }

    checks[#checks + 1] = "( find " .. beez.char.quote(root .. "/" .. cfg.js_dir)
        .. " -name '*.js' | head -1 | grep -q . )"
        .. " || ( test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " && find " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " -name '*.js' | head -1 | grep -q . )"

    return table.concat(checks, " && ")
end

function M.verify_scalajs(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.verify(cfg, root)
    if cfg.backend == "sbt" then
        return M.verify_sbt(cfg, root)
    end

    return M.verify_scalajs(cfg, root)
end

function M.test_sbt(cfg, root)
    local sbt = sbt_invocation(cfg)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        sbt,
        cfg.sbt_test_task,
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch "
        .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/scalajs-" .. cfg.profile_name .. ".ok")

    return table.concat(parts, " ")
end

function M.test_scalajs(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'scalajs standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/scalajs.ok"),
    }

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    if cfg.backend == "sbt" then
        return M.test_sbt(cfg, root)
    end

    return M.test_scalajs(cfg, root)
end

return M
