local M = {}

M.runnable = true

M.build_dir = "build/kotlin-native"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.kotlinc_native_binary = "kotlinc-native"
M.gradle_binary = "gradle"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[kotlin-native-setup]"
M.log_prefix_compile = "[kotlin-native-compile]"
M.log_prefix_bundle = "[kotlin-native-bundle]"
M.log_prefix_test = "[kotlin-native-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.gradle.kts",
    "build.gradle",
    "settings.gradle.kts",
    "settings.gradle",
    "gradle.properties",
    "gradlew",
    "gradlew.bat",
    "**/*.kt",
}

M.build_profiles = {
    code = {
        scope = "native",
        build_mode = "release",
        output_name = "app",
        kotlin_native_args = {},
        setup_description = "Resolve Kotlin/Native dependencies (Gradle or kotlinc-native)",
        compile_description = "Build Kotlin/Native executable (LLVM release)",
        bundle_description = "Verify Kotlin/Native binaries",
        test_description = "Run Kotlin/Native tests",
        test_args = "",
        gradle_link_task = "linkReleaseExecutableNative",
        gradle_test_task = "nativeTest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        kotlin_native_args = {},
        setup_description = "Resolve Kotlin/Native dependencies (debug)",
        compile_description = "Build Kotlin/Native executable (LLVM debug)",
        bundle_description = "Verify Kotlin/Native debug binaries",
        test_description = "Run Kotlin/Native tests (verbose)",
        test_args = "--info",
        gradle_link_task = "linkDebugExecutableNative",
        gradle_test_task = "nativeTest",
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
