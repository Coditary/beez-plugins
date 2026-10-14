local M = {}

M.runnable = true

M.build_dir = "build/asterius"
M.wasm_dir = M.build_dir .. "/wasm"
M.pseudo_exe_dir = M.build_dir .. "/pseudo-exe"
M.dist_dir = "dist-newstyle"
M.reports_dir = "report"

M.ahc_link_binary = "ahc-link"
M.ahc_cabal_binary = "ahc-cabal"
M.ahc_dist_binary = "ahc-dist"
M.asterius_binary = "asterius"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[asterius-setup]"
M.log_prefix_compile = "[asterius-compile]"
M.log_prefix_bundle = "[asterius-bundle]"
M.log_prefix_test = "[asterius-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.cabal",
    "stack.yaml",
    "stack.yaml.lock",
    "cabal.project",
    "cabal.project.local",
    "**/*.hs",
}

M.build_profiles = {
    wasm = {
        scope = "wasm",
        build_mode = "release",
        ahc_options = "",
        setup_description = "Update ahc-cabal index or verify Asterius toolchain",
        compile_description = "Compile Haskell to WebAssembly with Asterius (ahc)",
        bundle_description = "Verify Asterius Wasm artifacts",
        test_description = "Run Haskell tests via ahc-cabal",
        test_args = "",
        run_description = "Run application (wasm)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        ahc_options = "-O0 -g",
        setup_description = "Verify Asterius toolchain (debug)",
        compile_description = "Compile Haskell to WebAssembly with Asterius (debug, -O0 -g)",
        bundle_description = "Verify Asterius debug Wasm artifacts",
        test_description = "Run Haskell tests via ahc-cabal (verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "wasm",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:wasm"] = "wasm",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:wasm"] = "wasm",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "wasm",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:debug"] = "debug",
    ["run:wasm"] = "wasm",
}

return M
