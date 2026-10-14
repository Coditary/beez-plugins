local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function gradle_invocation(cfg)
    if cfg.use_gradle_wrapper then
        return "./gradlew"
    end
    return cfg.gradle_binary
end

local function native_image_args(cfg)
    local args = {}
    for _, arg in ipairs(cfg.native_image_args) do
        args[#args + 1] = arg
    end

    if cfg.parallelism ~= nil and cfg.parallelism ~= "" and cfg.parallelism ~= "0" then
        args[#args + 1] = "-J-XX:ActiveProcessorCount=" .. cfg.parallelism
    end

    return table.concat(args, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.graalvm-deps-resolved"

    if cfg.build_tool == "maven" then
        return table.concat({
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            cfg.maven_binary,
            "-B dependency:resolve",
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        gradle_invocation(cfg),
        "dependencies",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.package_jar(cfg, root)
    if cfg.build_tool == "maven" then
        return table.concat({
            project_cd(cfg, root),
            "&&",
            cfg.maven_binary,
            cfg.maven_package_args,
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        gradle_invocation(cfg),
        cfg.gradle_package_task,
    }, " ")
end

function M.find_jar_shell(cfg, root)
    local project = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        project = root .. "/" .. cfg.project_root
    end

    local search_dir
    if cfg.jar_path ~= nil and cfg.jar_path ~= "" then
        return "JAR=" .. beez.char.quote(project .. "/" .. cfg.jar_path)
    end

    if cfg.build_tool == "maven" then
        search_dir = project .. "/target"
    else
        search_dir = project .. "/build/libs"
    end

    return table.concat({
        "JAR=$(find",
        beez.char.quote(search_dir),
        "-maxdepth 1 -name '*.jar' -type f",
        "! -name '*-sources.jar' ! -name '*-javadoc.jar'",
        "! -name 'original-*' ! -name '*-plain.jar'",
        "| sort | head -1)",
        "&& test -n \"$JAR\"",
    }, " ")
end

function M.native_image(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local parts = {
        project_cd(cfg, root),
        "&&",
        M.find_jar_shell(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.native_image_binary,
        native_image_args(cfg),
    }

    if cfg.main_class ~= nil and cfg.main_class ~= "" then
        parts[#parts + 1] = "-H:Name=" .. beez.char.quote(cfg.output_name)
        parts[#parts + 1] = "-cp"
        parts[#parts + 1] = "\"$JAR\""
        parts[#parts + 1] = cfg.main_class
    else
        parts[#parts + 1] = "-jar"
        parts[#parts + 1] = "\"$JAR\""
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(output)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    return table.concat({
        M.package_jar(cfg, root),
        "&&",
        M.native_image(cfg, root),
    }, " ")
end

function M.verify_binary(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    return table.concat({
        "test -f " .. beez.char.quote(output),
        "&&",
        "test -x " .. beez.char.quote(output),
    }, " && ")
end

function M.test(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/graalvm-" .. cfg.profile_name .. ".ok"

    if cfg.build_tool == "maven" then
        return table.concat({
            project_cd(cfg, root),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            cfg.maven_binary,
            cfg.maven_test_args,
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        gradle_invocation(cfg),
        cfg.gradle_test_task,
        "&&",
        "touch " .. beez.char.quote(stamp),
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
