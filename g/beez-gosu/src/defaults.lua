local M = {}

M.runnable = true

M.build_dir = "build/gosu"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.gosu_binary = "gosu"
M.java_binary = "java"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gosu-setup]"
M.log_prefix_compile = "[gosu-compile]"
M.log_prefix_bundle = "[gosu-bundle]"
M.log_prefix_test = "[gosu-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.gs",
    "pom.xml",
    "**/pom.xml",
}

M.build_profiles = {
    code = {
        scope = "gosu",
        output_name = "app",
        setup_description = "Verify Gosu JVM compiler and prepare build directory",
        compile_description = "Compile Gosu sources with gosu compile",
        bundle_description = "Verify Gosu compile artifacts",
        test_description = "Run Gosu tests via Maven or gosu when present",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "gosu",
        output_name = "app",
        setup_description = "Verify Gosu JVM compiler (debug)",
        compile_description = "Compile Gosu sources with gosu compile (debug)",
        bundle_description = "Verify Gosu debug compile artifacts",
        test_description = "Run Gosu tests (verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
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
