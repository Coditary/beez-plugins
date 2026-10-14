local M = {}

M.runnable = true

M.build_dir = "build/swiftwasm"
M.wasm_dir = M.build_dir .. "/wasm"
M.debug_bin_dir = M.build_dir .. "/debug"
M.reports_dir = "report"

M.swift_binary = "swift"
M.wasm_ld_binary = "wasm-ld"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[swiftwasm-setup]"
M.log_prefix_compile = "[swiftwasm-compile]"
M.log_prefix_bundle = "[swiftwasm-bundle]"
M.log_prefix_test = "[swiftwasm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Package.swift",
    "Package@swift-5.9-wasm.swift",
    "Package.resolved",
    "**/*.swift",
}

M.build_profiles = {
    wasm = {
        scope = "wasm",
        build_mode = "release",
        build_path = M.build_dir,
        bin_dir = M.wasm_dir,
        configuration = "release",
        swift_sdk = "",
        extra_args = {},
        setup_description = "Resolve SwiftWasm package dependencies",
        compile_description = "Build with SwiftWasm SDK for WebAssembly",
        bundle_description = "Verify SwiftWasm artifacts",
        test_description = "Run SwiftWasm tests",
        test_args = "",
        test_filter = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        build_path = M.build_dir,
        bin_dir = M.debug_bin_dir,
        configuration = "debug",
        extra_args = {},
        setup_description = "Resolve SwiftWasm package dependencies (debug)",
        compile_description = "Build with SwiftWasm SDK (debug)",
        bundle_description = "Verify SwiftWasm debug artifacts",
        test_description = "Run SwiftWasm tests (verbose)",
        test_args = "--verbose",
        test_filter = "",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "wasm",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:code"] = "wasm",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "wasm",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "wasm",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:code"] = "wasm",
    ["run:debug"] = "debug",
}

return M
