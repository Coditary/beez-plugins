local M = {}

M.runnable = true

M.build_dir = "build/jython"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.jython_binary = "jython"
M.java_binary = "java"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jython-setup]"
M.log_prefix_compile = "[jython-compile]"
M.log_prefix_bundle = "[jython-bundle]"
M.log_prefix_test = "[jython-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.py",
}

M.compile_exclude = [[/(\.git|build|\.venv|local|__pycache__)/]]

M.build_profiles = {
    code = {
        scope = "jython",
        output_name = "app",
        setup_description = "Verify jython/java and prepare build directory",
        compile_description = "Compile Python sources to JVM bytecode (jython -m compileall)",
        bundle_description = "Verify jython bytecode artifacts",
        test_description = "Run primary Jython script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jython",
        output_name = "app",
        setup_description = "Verify jython/java and prepare build directory (debug)",
        compile_description = "Compile Python sources with jython -m compileall (debug)",
        bundle_description = "Verify jython debug bytecode artifacts",
        test_description = "Run primary Jython script (verbose)",
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
