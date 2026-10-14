local M = {}

M.runnable = true

M.build_dir = "build/groovy"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.groovy_binary = "groovyc"
M.prove_binary = "prove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[groovy-setup]"
M.log_prefix_compile = "[groovy-compile]"
M.log_prefix_bundle = "[groovy-bundle]"
M.log_prefix_test = "[groovy-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.groovy",
    "build.gradle",
    "**/build.gradle",
    "build.gradle.kts",
    "**/build.gradle.kts",
}

M.build_profiles = {
    code = {
        scope = "groovy",
        output_name = "app",
        setup_description = "Verify groovyc and prepare build directory",
        compile_description = "Compile Groovy sources with groovyc",
        bundle_description = "Verify Groovy compile artifacts",
        test_description = "Run Groovy tests in t/ with prove",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "groovy",
        output_name = "app",
        setup_description = "Verify groovyc and prepare build directory (debug)",
        compile_description = "Compile Groovy sources with groovyc (debug)",
        bundle_description = "Verify Groovy debug compile artifacts",
        test_description = "Run Groovy tests in t/ with prove (verbose)",
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
