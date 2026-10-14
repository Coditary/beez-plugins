local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

local function source_relative_to_project(cfg, source)
    local root = cfg.project_root
    if root == nil or root == "." or root == "" then
        return source
    end

    local prefix = root .. "/"
    if source:sub(1, #prefix) == prefix then
        return source:sub(#prefix + 1)
    end

    return source
end

local function quoted_sources(cfg)
    local quoted = {}
    for _, source in ipairs(cfg.sources) do
        quoted[#quoted + 1] = beez.char.quote(source_relative_to_project(cfg, source))
    end
    return table.concat(quoted, " ")
end

local function classpath_file(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/classpath.txt"
end

local function deps_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.deps-fetched"
end

local function gradle_init_file(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/gradle-classpath-init.gradle"
end

function M.gradle_init_script()
    return table.concat({
        "allprojects {",
        "  tasks.register('beezClasspath') {",
        "    doLast {",
        "      def cfg = configurations.findByName('compileClasspath')",
        "      if (cfg == null) { cfg = configurations.findByName('implementation') }",
        "      if (cfg != null) { println cfg.asPath }",
        "    }",
        "  }",
        "}",
    }, "\n")
end

function M.dependency_fetch(cfg, root)
    local stamp = deps_stamp(cfg, root)
    local mkdir = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    local touch = "touch " .. beez.char.quote(stamp)

    if cfg.build_system == "maven" then
        return table.concat({
            mkdir,
            "&&",
            "cd " .. beez.char.quote(project_dir(cfg, root)),
            "&&",
            cfg.maven_binary,
            "-B -q dependency:resolve dependency:resolve-plugins",
            "&&",
            touch,
        }, " ")
    end

    if cfg.build_system == "gradle" then
        return table.concat({
            mkdir,
            "&&",
            "cd " .. beez.char.quote(project_dir(cfg, root)),
            "&&",
            cfg.gradle_command,
            "--console=plain dependencies",
            "&&",
            touch,
        }, " ")
    end

    return mkdir .. " && " .. touch
end

function M.build_classpath(cfg, root)
    local cp_file = classpath_file(cfg, root)
    local mkdir = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)

    if cfg.build_system == "maven" then
        return table.concat({
            mkdir,
            "&&",
            "cd " .. beez.char.quote(project_dir(cfg, root)),
            "&&",
            cfg.maven_binary,
            "-B -q dependency:build-classpath -Dmdep.outputFile=" .. beez.char.quote(cp_file),
        }, " ")
    end

    if cfg.build_system == "gradle" then
        local init_file = gradle_init_file(cfg, root)
        return table.concat({
            mkdir,
            "&&",
            "cat > " .. beez.char.quote(init_file) .. " <<'BEEZ_EOF'\n",
            M.gradle_init_script(),
            "\nBEEZ_EOF",
            "&&",
            "cd " .. beez.char.quote(project_dir(cfg, root)),
            "&&",
            cfg.gradle_command,
            "-I " .. beez.char.quote(init_file),
            "beezClasspath -q > " .. beez.char.quote(cp_file),
        }, " ")
    end

    return mkdir .. " && : > " .. beez.char.quote(cp_file)
end

function M.compile_all(cfg, root)
    local cp_file = classpath_file(cfg, root)
    local classes = root .. "/" .. cfg.classes_dir

    local parts = {
        M.build_classpath(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(classes),
        "&&",
        "cd " .. beez.char.quote(project_dir(cfg, root)),
        "&&",
        "CP=$(cat " .. beez.char.quote(cp_file) .. ")",
        "&&",
        cfg.javac_binary,
        "-encoding " .. beez.char.quote(cfg.encoding),
    }

    if cfg.javac_flags ~= nil and cfg.javac_flags ~= "" then
        parts[#parts + 1] = cfg.javac_flags
    end

    parts[#parts + 1] = "-d"
    parts[#parts + 1] = beez.char.quote(classes)
    parts[#parts + 1] = "-classpath"
    parts[#parts + 1] = "\"$CP:" .. classes .. "\""
    parts[#parts + 1] = quoted_sources(cfg)

    return table.concat(parts, " ")
end

function M.install_launcher(cfg, root)
    local classes = root .. "/" .. cfg.classes_dir
    local bin_dir = root .. "/" .. cfg.bin_dir
    local launcher = bin_dir .. "/run"
    local main_class = cfg.main_class or "Main"

    local verify = "test -d " .. beez.char.quote(classes)
    local write_launcher = table.concat({
        "mkdir -p " .. beez.char.quote(bin_dir),
        "&&",
        "printf '%s\\n' '#!/bin/sh'",
        "'exec " .. cfg.java_binary .. " -classpath " .. classes .. " " .. main_class .. " \"$@\"' > " .. beez.char.quote(launcher),
        "&&",
        "chmod +x " .. beez.char.quote(launcher),
    }, " ")

    return verify .. " && " .. write_launcher
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/javac-" .. cfg.profile_name .. ".ok"
    local mkdir = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test")

    if cfg.build_system == "maven" then
        local parts = {
            mkdir,
            "&&",
            "cd " .. beez.char.quote(project_dir(cfg, root)),
            "&&",
            cfg.maven_binary,
            "-B test",
        }
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(report)
        return table.concat(parts, " ")
    end

    if cfg.build_system == "gradle" then
        local parts = {
            mkdir,
            "&&",
            "cd " .. beez.char.quote(project_dir(cfg, root)),
            "&&",
            cfg.gradle_command,
            "test",
        }
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(report)
        return table.concat(parts, " ")
    end

    local classes = root .. "/" .. cfg.classes_dir
    local main_class = cfg.main_class
    if main_class == nil then
        return mkdir .. " && touch " .. beez.char.quote(report)
    end

    return table.concat({
        mkdir,
        "&&",
        "cd " .. beez.char.quote(project_dir(cfg, root)),
        "&&",
        cfg.java_binary,
        "-classpath " .. beez.char.quote(classes),
        main_class,
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
