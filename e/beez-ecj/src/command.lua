local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end
    return "cd " .. beez.char.quote(dir)
end

local function ecj_invocation(cfg)
    if cfg.ecj_jar ~= nil and cfg.ecj_jar ~= "" then
        return cfg.java_binary .. " -jar " .. beez.char.quote(cfg.ecj_jar)
    end
    return cfg.ecj_binary
end

local function classpath_arg(cfg, root)
    local cp_file = root .. "/" .. cfg.classpath_file
    return "if [ -f " .. beez.char.quote(cp_file) .. " ]; then "
        .. "CP=\"$(cat " .. beez.char.quote(cp_file) .. ")\"; "
        .. "else CP=\"\"; fi"
end

local function source_find_args(cfg)
    local globs = {}
    for _, source_root in ipairs(cfg.source_roots) do
        globs[#globs + 1] = "-path " .. beez.char.quote(source_root .. "/*.java")
        globs[#globs + 1] = "-o -path " .. beez.char.quote(source_root .. "/**/*.java")
    end

    if #globs == 0 then
        return "-name '*.java'"
    end

    return table.concat(globs, " ")
end

function M.resolve_dependencies(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ecj-deps-resolved"
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
    }

    if cfg.project_type == "maven" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.maven_binary
        parts[#parts + 1] = "-q dependency:resolve"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.maven_binary
        parts[#parts + 1] = "-q dependency:build-classpath"
        parts[#parts + 1] = "-Dmdep.outputFile=" .. beez.char.quote(root .. "/" .. cfg.classpath_file)
    elseif cfg.project_type == "gradle" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.gradle_binary
        parts[#parts + 1] = "dependencies"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local classes_out = root .. "/" .. cfg.classes_dir
    local source_args = source_find_args(cfg)

    local parts = {
        project_cd(cfg, root),
        "&&",
        classpath_arg(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(classes_out),
        "&&",
        "SOURCES=\"$(find . " .. source_args .. " 2>/dev/null | tr '\\n' ' ')\"",
        "&&",
        "test -n \"$SOURCES\"",
        "&&",
        ecj_invocation(cfg),
        "-d " .. beez.char.quote(classes_out),
        "-source " .. beez.char.quote(cfg.source_level),
        "-target " .. beez.char.quote(cfg.target_level),
        "-classpath \"$CP\"",
    }

    for _, arg in ipairs(cfg.ecj_args) do
        parts[#parts + 1] = arg
    end

    parts[#parts + 1] = "$SOURCES"

    return table.concat(parts, " ")
end

function M.verify_classes(cfg, root)
    local classes_out = root .. "/" .. cfg.classes_dir
    return table.concat({
        "test -d " .. beez.char.quote(classes_out),
        "&&",
        "find " .. beez.char.quote(classes_out) .. " -name '*.class' | head -1 | grep -q .",
    }, " ")
end

function M.test(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/java-" .. cfg.profile_name .. ".ok"
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    if cfg.project_type == "maven" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.maven_binary
        parts[#parts + 1] = "-q test"
    elseif cfg.project_type == "gradle" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.gradle_binary
        parts[#parts + 1] = "test"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
    else
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = classpath_arg(cfg, root)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "TEST_SOURCES=\"$(find . -path './src/test/java/*.java' -o -path './src/test/java/**/*.java' 2>/dev/null | tr '\\n' ' ')\""
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "if [ -n \"$TEST_SOURCES\" ]; then "
            .. ecj_invocation(cfg)
            .. " -d " .. beez.char.quote(root .. "/" .. cfg.classes_dir)
            .. " -source " .. beez.char.quote(cfg.source_level)
            .. " -target " .. beez.char.quote(cfg.target_level)
            .. " -classpath \"$CP\" $TEST_SOURCES; "
            .. "else echo 'no test sources found'; fi"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

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
