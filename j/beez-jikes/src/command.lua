local M = {}

local function quoted_sources(sources, root)
    local quoted = {}
    for _, path in ipairs(sources) do
        quoted[#quoted + 1] = beez.char.quote(root .. "/" .. path)
    end
    return quoted
end

local function classpath_arg(cfg, root, extra)
    local parts = {}
    if cfg.classpath ~= nil and cfg.classpath ~= "" then
        parts[#parts + 1] = cfg.classpath
    end
    parts[#parts + 1] = root .. "/" .. cfg.classes_dir

    if extra ~= nil and extra ~= "" then
        parts[#parts + 1] = extra
    end

    return "-classpath " .. beez.char.quote(table.concat(parts, ":"))
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.jikes-setup"

    return table.concat({
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.classes_dir),
        "&&",
        cfg.jikes_binary,
        "+version",
        "&&",
        "touch",
        beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    if #cfg.main_sources == 0 then
        error("jikes compile: no main Java sources found")
    end

    local parts = {
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.classes_dir),
        "&&",
        cfg.jikes_binary,
        "-d",
        beez.char.quote(root .. "/" .. cfg.classes_dir),
    }

    if cfg.source_root ~= nil and cfg.source_root ~= "" and cfg.source_root ~= "." then
        parts[#parts + 1] = "-sourcepath"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.source_root)
    end

    if cfg.classpath ~= nil and cfg.classpath ~= "" then
        parts[#parts + 1] = "-classpath"
        parts[#parts + 1] = beez.char.quote(cfg.classpath)
    end

    for _, flag in ipairs(cfg.compile_flags) do
        parts[#parts + 1] = flag
    end

    for _, source in ipairs(quoted_sources(cfg.main_sources, root)) do
        parts[#parts + 1] = source
    end

    return table.concat(parts, " ")
end

function M.bundle(cfg, root)
    local classes_root = root .. "/" .. cfg.classes_dir
    local jar_path = root .. "/" .. cfg.jar_path

    return table.concat({
        "test -d",
        beez.char.quote(classes_root),
        "&&",
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        cfg.jar_binary,
        "cf",
        beez.char.quote(jar_path),
        "-C",
        beez.char.quote(classes_root),
        ".",
    }, " ")
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/jikes-" .. cfg.profile_name .. ".ok"

    if #cfg.test_sources == 0 then
        return table.concat({
            "mkdir -p",
            beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            "echo 'no Java test sources found; skipping Jikes tests'",
            "&&",
            "touch",
            beez.char.quote(report),
        }, " ")
    end

    local parts = {
        "mkdir -p",
        beez.char.quote(root .. "/" .. cfg.classes_dir),
        "&&",
        cfg.jikes_binary,
        "-d",
        beez.char.quote(root .. "/" .. cfg.classes_dir),
    }

    if cfg.source_root ~= nil and cfg.source_root ~= "" and cfg.source_root ~= "." then
        parts[#parts + 1] = "-sourcepath"
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.source_root)
    end

    parts[#parts + 1] = classpath_arg(cfg, root, cfg.test_classpath)

    for _, flag in ipairs(cfg.compile_flags) do
        parts[#parts + 1] = flag
    end

    for _, source in ipairs(quoted_sources(cfg.test_sources, root)) do
        parts[#parts + 1] = source
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test")
    parts[#parts + 1] = "&&"

    local run_parts = {}
    for _, class_name in ipairs(cfg.test_classes) do
        run_parts[#run_parts + 1] = table.concat({
            cfg.java_binary,
            classpath_arg(cfg, root, cfg.test_classpath),
            "org.junit.runner.JUnitCore",
            class_name,
        }, " ")
    end

    parts[#parts + 1] = table.concat(run_parts, " && ")
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch"
    parts[#parts + 1] = beez.char.quote(report)

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
