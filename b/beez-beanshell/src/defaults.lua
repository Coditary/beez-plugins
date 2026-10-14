local M = {}

M.runnable = true

M.build_dir = "build/beanshell"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.java_binary = "java"
M.bsh_jar = "bsh.jar"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[beanshell-setup]"
M.log_prefix_compile = "[beanshell-compile]"
M.log_prefix_bundle = "[beanshell-bundle]"
M.log_prefix_test = "[beanshell-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.bsh",
}

M.build_profiles = {
    code = {
        scope = "beanshell",
        output_name = "app",
        compile_flags = "",
        setup_description = "Verify JRE and BeanShell (bsh.jar)",
        compile_description = "Compile BeanShell scripts with bsh.Interpreter",
        bundle_description = "Verify BeanShell build artifacts",
        test_description = "Run BeanShell scripts with JRE",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "beanshell",
        output_name = "app",
        compile_flags = "-debug",
        setup_description = "Verify JRE and BeanShell (debug)",
        compile_description = "Compile BeanShell scripts with debug tracing",
        bundle_description = "Verify BeanShell debug artifacts",
        test_description = "Run BeanShell scripts (verbose)",
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
