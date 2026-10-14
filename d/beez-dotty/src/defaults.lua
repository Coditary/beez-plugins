local M = {}

M.runnable = true

M.build_dir = "build/dotty"
M.classes_dir = M.build_dir .. "/classes"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.scalac_binary = "scalac"
M.sbt_binary = "sbt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[dotty-setup]"
M.log_prefix_compile = "[dotty-compile]"
M.log_prefix_bundle = "[dotty-bundle]"
M.log_prefix_test = "[dotty-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.sbt",
    "project/build.properties",
    "project/plugins.sbt",
    "project/*.scala",
    "src/**/*.scala",
    "**/*.scala",
}

M.build_profiles = {
    code = {
        scope = "dotty",
        build_mode = "release",
        output_name = "app",
        scalac_args = {},
        jvm_target = "21",
        setup_description = "Resolve Scala 3 / Dotty dependencies (sbt update or scalac)",
        compile_description = "Compile Scala 3 sources to JVM bytecode",
        bundle_description = "Verify Scala 3 / Dotty build artifacts",
        test_description = "Run Scala 3 / Dotty tests",
        test_args = "",
        sbt_compile_task = "compile",
        sbt_test_task = "test",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        scalac_args = { "-g:vars" },
        jvm_target = "21",
        setup_description = "Resolve Scala 3 / Dotty dependencies (debug)",
        compile_description = "Compile Scala 3 sources to JVM bytecode (debug)",
        bundle_description = "Verify Scala 3 / Dotty debug artifacts",
        test_description = "Run Scala 3 / Dotty tests (verbose)",
        test_args = "-v",
        sbt_compile_task = "compile",
        sbt_test_task = "test",
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
