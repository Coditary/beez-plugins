local M = {}

M.runnable = true

M.build_dir = "build/scalac"
M.classes_dir = M.build_dir .. "/classes"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.scalac_binary = "scalac"
M.sbt_binary = "sbt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[scalac-setup]"
M.log_prefix_compile = "[scalac-compile]"
M.log_prefix_bundle = "[scalac-bundle]"
M.log_prefix_test = "[scalac-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.sbt",
    "build.sc",
    "project/build.properties",
    "project/plugins.sbt",
    "project/*.scala",
    "src/**/*.scala",
    "**/*.scala",
}

M.build_profiles = {
    code = {
        scope = "jvm",
        build_mode = "release",
        output_name = "app",
        scalac_args = {},
        jvm_target = "21",
        setup_description = "Resolve Scala/JVM dependencies (sbt update or scalac)",
        compile_description = "Compile Scala sources to JVM bytecode",
        bundle_description = "Verify Scala/JVM build artifacts",
        test_description = "Run Scala/JVM tests",
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
        setup_description = "Resolve Scala/JVM dependencies (debug)",
        compile_description = "Compile Scala sources to JVM bytecode (debug)",
        bundle_description = "Verify Scala/JVM debug artifacts",
        test_description = "Run Scala/JVM tests (verbose)",
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
