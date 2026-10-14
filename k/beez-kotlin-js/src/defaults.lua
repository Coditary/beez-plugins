local M = {}

M.runnable = true

M.build_dir = "build/kotlin-js"
M.js_dir = M.build_dir .. "/js"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.kotlinc_js_binary = "kotlinc-js"
M.gradle_binary = "gradle"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[kotlin-js-setup]"
M.log_prefix_compile = "[kotlin-js-compile]"
M.log_prefix_bundle = "[kotlin-js-bundle]"
M.log_prefix_test = "[kotlin-js-test]"

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
    "src/**/*.kt",
    "**/*.kt",
}

M.build_profiles = {
    code = {
        scope = "js",
        build_mode = "release",
        output_name = "app",
        kotlin_args = {},
        module_kind = "umd",
        source_map = false,
        setup_description = "Resolve Kotlin/JS dependencies (Gradle or kotlinc-js)",
        compile_description = "Transpile Kotlin sources to JavaScript",
        bundle_description = "Verify Kotlin/JS build artifacts",
        test_description = "Run Kotlin/JS tests",
        test_args = "",
        gradle_compile_task = "compileKotlinJs",
        gradle_test_task = "jsTest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        kotlin_args = { "-source-map" },
        module_kind = "umd",
        source_map = true,
        setup_description = "Resolve Kotlin/JS dependencies (debug)",
        compile_description = "Transpile Kotlin sources to JavaScript (debug, source maps)",
        bundle_description = "Verify Kotlin/JS debug artifacts",
        test_description = "Run Kotlin/JS tests (verbose)",
        test_args = "--info",
        gradle_compile_task = "compileKotlinJs",
        gradle_test_task = "jsTest",
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
