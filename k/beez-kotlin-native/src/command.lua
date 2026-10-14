local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function gradle_invocation(cfg, root)
    if cfg.gradlew ~= nil then
        local wrapper = root .. "/" .. cfg.gradlew
        return beez.char.quote(wrapper)
    end

    return cfg.gradle_binary
end

local function collect_native_binaries(cfg, root)
    local bin_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)
    return table.concat({
        "mkdir -p " .. bin_dir,
        "&&",
        "if [ -d build/bin ]; then",
        "find build/bin -type f \\( -perm -111 -o -name '*.kexe' -o -name '*.exe' \\)",
        "-exec cp -f {} " .. bin_dir .. "/ \\;;",
        "fi",
    }, " ")
end

function M.setup_gradle(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.kotlin-native-setup"
    local gradle = gradle_invocation(cfg, root)

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        gradle,
        "dependencies",
        "--quiet",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup_kotlinc_native(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.kotlin-native-setup"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup(cfg, root)
    if cfg.backend == "gradle" then
        
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

return M.setup_gradle(cfg, root)
    end

    return M.setup_kotlinc_native(cfg, root)
end

function M.compile_gradle(cfg, root)
    local gradle = gradle_invocation(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        gradle,
        cfg.gradle_link_task,
        "&&",
        collect_native_binaries(cfg, root),
    }

    return table.concat(parts, " ")
end

function M.compile_kotlinc_native(cfg, root)
    if #cfg.sources == 0 then
        error("kotlin-native plugin: no Kotlin source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(root .. "/" .. source)
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.kotlinc_native_binary,
        table.concat(quoted_sources, " "),
        "-o",
        beez.char.quote(root .. "/" .. cfg.primary_output),
    }

    for _, arg in ipairs(cfg.kotlin_native_args) do
        parts[#parts + 1] = arg
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    if cfg.backend == "gradle" then
        return M.compile_gradle(cfg, root)
    end

    return M.compile_kotlinc_native(cfg, root)
end

function M.verify_gradle(cfg, root)
    return "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " && find " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " -type f | head -1 | grep -q ."
end

function M.verify_kotlinc_native(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.verify(cfg, root)
    if cfg.backend == "gradle" then
        return M.verify_gradle(cfg, root)
    end

    return M.verify_kotlinc_native(cfg, root)
end

function M.test_gradle(cfg, root)
    local gradle = gradle_invocation(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        gradle,
        cfg.gradle_test_task,
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    return table.concat(parts, " ")
end

function M.test_kotlinc_native(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'kotlinc-native standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/kotlin-native-kotlinc-native.ok"),
    }

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    if cfg.backend == "gradle" then
        return M.test_gradle(cfg, root)
    end

    return M.test_kotlinc_native(cfg, root)
end

return M
