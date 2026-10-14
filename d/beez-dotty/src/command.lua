local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup_sbt(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.dotty-setup"

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        cfg.sbt_binary,
        "-batch",
        "-Dsbt.supershell=false",
        "update",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup_scalac(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.dotty-setup"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.classes_dir),
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

    return M.setup_scalac(cfg, root)
end

function M.compile_sbt(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.classes_dir),
        "&&",
        cfg.sbt_binary,
        "-batch",
        "-Dsbt.supershell=false",
        cfg.sbt_compile_task,
    }

    if cfg.build_mode == "debug" then
        parts[#parts + 1] = "-v"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "for d in target/scala-*/classes; do if [ -d \"$d\" ]; then cp -a \"$d\"/. "
        .. beez.char.quote(root .. "/" .. cfg.classes_dir) .. "/; break; fi; done"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find target -maxdepth 3 -name '*.jar' -exec cp -a {} "
        .. beez.char.quote(root .. "/" .. cfg.bin_dir) .. "/ \\; 2>/dev/null || true"

    return table.concat(parts, " ")
end

function M.compile_scalac(cfg, root)
    if #cfg.sources == 0 then
        error("dotty plugin: no Scala source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(root .. "/" .. source)
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.classes_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.scalac_binary,
        table.concat(quoted_sources, " "),
        "-d",
        beez.char.quote(root .. "/" .. cfg.classes_dir),
        "-release:" .. cfg.jvm_target,
    }

    for _, arg in ipairs(cfg.scalac_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    if cfg.backend == "sbt" then
        return M.compile_sbt(cfg, root)
    end

    return M.compile_scalac(cfg, root)
end

function M.verify_sbt(cfg, root)
    local checks = {
        "test -d " .. beez.char.quote(root .. "/" .. cfg.classes_dir),
    }

    checks[#checks + 1] = "( test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " && ls " .. beez.char.quote(root .. "/" .. cfg.bin_dir) .. "/*.jar >/dev/null 2>&1 )"
        .. " || test -d " .. beez.char.quote(root .. "/" .. cfg.classes_dir)

    return table.concat(checks, " && ")
end

function M.verify_scalac(cfg, root)
    return "test -d " .. beez.char.quote(root .. "/" .. cfg.classes_dir)
        .. " && find " .. beez.char.quote(root .. "/" .. cfg.classes_dir)
        .. " -name '*.class' | head -1 | grep -q ."
end

function M.verify(cfg, root)
    if cfg.backend == "sbt" then
        return M.verify_sbt(cfg, root)
    end

    return M.verify_scalac(cfg, root)
end

function M.test_sbt(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.sbt_binary,
        "-batch",
        "-Dsbt.supershell=false",
        cfg.sbt_test_task,
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    return table.concat(parts, " ")
end

function M.test_scalac(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'dotty standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/dotty-scalac.ok"),
    }

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    if cfg.backend == "sbt" then
        return M.test_sbt(cfg, root)
    end

    return M.test_scalac(cfg, root)
end

return M
