local M = {}

M.runnable = true

M.build_dir = "build/jikes"
M.classes_dir = M.build_dir .. "/classes"
M.jar_path = M.build_dir .. "/app.jar"
M.reports_dir = "report"

M.jikes_binary = "jikes"
M.java_binary = "java"
M.jar_binary = "jar"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jikes-setup]"
M.log_prefix_compile = "[jikes-compile]"
M.log_prefix_bundle = "[jikes-bundle]"
M.log_prefix_test = "[jikes-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.java",
}

M.build_profiles = {
    code = {
        scope = "jikes",
        build_mode = "release",
        compile_flags = {},
        setup_description = "Prepare Jikes build directories and verify compiler",
        compile_description = "Compile Java sources with Jikes",
        bundle_description = "Package Jikes class files into JAR",
        test_description = "Run JUnit tests (requires JUnit on classpath)",
        test_args = "",
    },

    debug = {
        scope = "jikes",
        build_mode = "debug",
        compile_flags = { "-g" },
        setup_description = "Prepare Jikes build directories (debug)",
        compile_description = "Compile Java sources with Jikes (debug symbols)",
        bundle_description = "Verify Jikes debug class artifacts",
        test_description = "Run JUnit tests with Jikes debug build",
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
