local M = {}

M.runnable = true

M.build_dir = "build/graalvm"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.native_image_binary = "native-image"
M.maven_binary = "mvn"
M.gradle_binary = "gradle"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[graalvm-setup]"
M.log_prefix_compile = "[graalvm-compile]"
M.log_prefix_bundle = "[graalvm-bundle]"
M.log_prefix_test = "[graalvm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "**/*.java",
    "META-INF/native-image/**",
}

M.build_profiles = {
    native = {
        scope = "native",
        build_mode = "release",
        output_name = "app",
        native_image_args = { "--no-fallback", "-O2" },
        maven_package_args = "-B -DskipTests package",
        gradle_package_task = "jar",
        setup_description = "Resolve Maven/Gradle dependencies for GraalVM native-image",
        compile_description = "Compile Java to native binary via native-image (AOT)",
        bundle_description = "Verify GraalVM native binary artifacts",
        test_description = "Run Java unit tests (Maven/Gradle)",
        maven_test_args = "-B test",
        gradle_test_task = "test",
    },

    debug = {
        scope = "native",
        build_mode = "debug",
        output_name = "app",
        native_image_args = { "--no-fallback", "-O0", "-g" },
        maven_package_args = "-B -DskipTests package",
        gradle_package_task = "jar",
        setup_description = "Resolve Maven/Gradle dependencies (native debug)",
        compile_description = "Compile Java to native binary via native-image (debug)",
        bundle_description = "Verify GraalVM native debug artifacts",
        test_description = "Run Java unit tests (verbose)",
        maven_test_args = "-B test",
        gradle_test_task = "test",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "native",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:native"] = "native",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:native"] = "native",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "native",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:debug"] = "debug",
    ["run:native"] = "native",
}

return M
