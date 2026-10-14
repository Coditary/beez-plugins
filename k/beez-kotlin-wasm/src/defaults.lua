local M = {}

M.runnable = true

M.build_dir = "build/kotlin-wasm"
M.wasm_dir = M.build_dir .. "/wasm"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.kotlin_wasm_binary = "kotlin-wasm"
M.gradle_binary = "gradle"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[kotlin-wasm-setup]"
M.log_prefix_compile = "[kotlin-wasm-compile]"
M.log_prefix_bundle = "[kotlin-wasm-bundle]"
M.log_prefix_test = "[kotlin-wasm-test]"

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
        scope = "wasm",
        build_mode = "release",
        output_name = "app",
        kotlin_args = {},
        source_map = false,
        setup_description = "Resolve Kotlin/Wasm dependencies (Gradle or kotlin-wasm)",
        compile_description = "Compile Kotlin sources to WebAssembly",
        bundle_description = "Verify Kotlin/Wasm build artifacts",
        test_description = "Run Kotlin/Wasm tests",
        test_args = "",
        gradle_compile_task = "compileProductionExecutableWasmJs",
        gradle_test_task = "wasmJsBrowserTest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        kotlin_args = { "-source-map" },
        source_map = true,
        setup_description = "Resolve Kotlin/Wasm dependencies (debug)",
        compile_description = "Compile Kotlin sources to WebAssembly (debug, source maps)",
        bundle_description = "Verify Kotlin/Wasm debug artifacts",
        test_description = "Run Kotlin/Wasm tests (verbose)",
        test_args = "--info",
        gradle_compile_task = "compileDevelopmentExecutableWasmJs",
        gradle_test_task = "wasmJsBrowserTest",
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
