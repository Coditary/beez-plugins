local M = {}

M.runnable = true

M.build_dir = "build/tinygo"
M.wasm_dir = M.build_dir .. "/wasm"
M.embedded_dir = M.build_dir .. "/embedded"
M.reports_dir = "report"

M.go_binary = "go"
M.tinygo_binary = "tinygo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[tinygo-setup]"
M.log_prefix_compile = "[tinygo-compile]"
M.log_prefix_bundle = "[tinygo-bundle]"
M.log_prefix_test = "[tinygo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "go.mod",
    "go.sum",
    "**/*.go",
}

M.build_profiles = {
    wasm = {
        scope = "wasm",
        build_mode = "release",
        output_name = "app",
        bin_dir = M.wasm_dir,
        tinygo_target = "wasm",
        tinygo_opt = "2",
        tinygo_gc = "leaking",
        tinygo_size = "short",
        tags = {},
        setup_description = "Prepare TinyGo Wasm build",
        compile_description = "Build with TinyGo for WebAssembly",
        bundle_description = "Verify TinyGo Wasm artifact",
        test_description = "Run TinyGo Wasm tests",
        test_args = "-count=1",
        test_packages = "./...",
    },

    wasi = {
        scope = "wasm",
        build_mode = "release",
        output_name = "app",
        bin_dir = M.wasm_dir,
        tinygo_target = "wasi",
        tinygo_opt = "2",
        tinygo_gc = "leaking",
        tinygo_size = "short",
        tags = {},
        setup_description = "Prepare TinyGo WASI build",
        compile_description = "Build with TinyGo for WASI",
        bundle_description = "Verify TinyGo WASI artifact",
        test_description = "Run TinyGo WASI tests",
        test_args = "-count=1",
        test_packages = "./...",
    },

    embedded = {
        scope = "embedded",
        build_mode = "release",
        output_name = "firmware",
        bin_dir = M.embedded_dir,
        tinygo_target = "arduino",
        tinygo_opt = "2",
        tinygo_gc = "leaking",
        tinygo_size = "short",
        tags = {},
        setup_description = "Prepare TinyGo embedded build",
        compile_description = "Build with TinyGo for embedded/MCU",
        bundle_description = "Verify TinyGo firmware artifact",
        test_description = "Run TinyGo embedded tests",
        test_args = "-count=1",
        test_packages = "./...",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        bin_dir = M.wasm_dir,
        tinygo_target = "wasm",
        tinygo_opt = "0",
        tinygo_gc = "leaking",
        tinygo_size = "normal",
        tags = {},
        setup_description = "Prepare TinyGo debug Wasm build",
        compile_description = "Build with TinyGo for WebAssembly (debug, -opt=0)",
        bundle_description = "Verify TinyGo debug Wasm artifact",
        test_description = "Run TinyGo debug Wasm tests",
        test_args = "-v -count=1",
        test_packages = "./...",
    },
}

M.configure_step_profiles = {
    ["tinygo:configure"] = "wasm",
    ["tinygo:configure:wasi"] = "wasi",
    ["tinygo:configure:embedded"] = "embedded",
    ["tinygo:configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["tinygo:compile"] = "wasm",
    ["tinygo:compile:wasi"] = "wasi",
    ["tinygo:compile:embedded"] = "embedded",
    ["tinygo:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["tinygo:bundle"] = "wasm",
    ["tinygo:bundle:wasi"] = "wasi",
    ["tinygo:bundle:embedded"] = "embedded",
    ["tinygo:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["tinygo:test"] = "wasm",
    ["tinygo:test:wasi"] = "wasi",
    ["tinygo:test:embedded"] = "embedded",
    ["tinygo:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["tinygo:run"] = "wasm",
    ["tinygo:run:debug"] = "debug",
    ["tinygo:run:embedded"] = "embedded",
    ["tinygo:run:wasi"] = "wasi",
}

return M
