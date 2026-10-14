local M = {}

M.runnable = true

M.build_dir = "build/scala-native"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.scala_native_binary = "scala-native"
M.sbt_binary = "sbt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[scala-native-setup]"
M.log_prefix_compile = "[scala-native-compile]"
M.log_prefix_bundle = "[scala-native-bundle]"
M.log_prefix_test = "[scala-native-test]"

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
        scope = "native",
        build_mode = "release",
        output_name = "app",
        scala_native_args = {},
        setup_description = "Resolve Scala/Native dependencies (sbt update or scala-native)",
        compile_description = "Build Scala/Native executable (LLVM release via nativeLink)",
        bundle_description = "Verify Scala/Native binaries",
        test_description = "Run Scala/Native tests",
        test_args = "",
        sbt_link_task = "nativeLink",
        sbt_test_task = "test",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        scala_native_args = {},
        setup_description = "Resolve Scala/Native dependencies (debug)",
        compile_description = "Build Scala/Native executable (LLVM debug via nativeLink)",
        bundle_description = "Verify Scala/Native debug binaries",
        test_description = "Run Scala/Native tests (verbose)",
        test_args = "-v",
        sbt_link_task = "nativeLink",
        sbt_link_prefix = "set nativeConfig ~= _.withMode(native.Mode.debug)",
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
