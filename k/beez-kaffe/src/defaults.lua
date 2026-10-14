local M = {}

M.runnable = true

M.build_dir = "build/kaffe"
M.classes_dir = M.build_dir .. "/classes"
M.jar_path = M.build_dir .. "/app.jar"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.kaffe_binary = "kaffe"
M.kaffec_binary = "kaffec"
M.jar_binary = "jar"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[kaffe-setup]"
M.log_prefix_compile = "[kaffe-compile]"
M.log_prefix_bundle = "[kaffe-bundle]"
M.log_prefix_test = "[kaffe-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.java",
}

M.build_profiles = {
    code = {
        scope = "kaffe",
        build_mode = "release",
        compile_flags = {},
        setup_description = "Prepare Kaffe build directories and verify JVM",
        compile_description = "Compile Java sources with kaffec",
        bundle_description = "Package Kaffe class files into JAR",
        test_description = "Run tests on the Kaffe JVM",
        test_args = "",
    },

    debug = {
        scope = "kaffe",
        build_mode = "debug",
        compile_flags = { "-g" },
        setup_description = "Prepare Kaffe build directories (debug)",
        compile_description = "Compile Java sources with kaffec (debug symbols)",
        bundle_description = "Verify Kaffe debug class artifacts",
        test_description = "Run tests on the Kaffe JVM (debug build)",
        test_args = "",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
