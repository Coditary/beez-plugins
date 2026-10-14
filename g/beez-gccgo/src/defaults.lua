local M = {}

M.runnable = true

M.build_dir = "build/gccgo"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.go_binary = "go"
M.gccgo_binary = "gccgo"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gccgo-setup]"
M.log_prefix_compile = "[gccgo-compile]"
M.log_prefix_bundle = "[gccgo-bundle]"
M.log_prefix_test = "[gccgo-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "go.mod",
    "go.sum",
    "**/*.go",
}

M.build_profiles = {
    code = {
        scope = "gccgo",
        build_mode = "release",
        output_name = "app",
        use_go_frontend = true,
        gccgo_optimize = true,
        cgo_enabled = "1",
        ldflags = "",
        tags = {},
        setup_description = "Download Go module dependencies (gccgo)",
        compile_description = "Build with gccgo (GCC frontend, cross-arch optimization)",
        bundle_description = "Verify gccgo build artifacts",
        test_description = "Run tests with gccgo",
        test_args = "-count=1",
        test_packages = "./...",
    },

    debug = {
        scope = "gccgo",
        build_mode = "debug",
        output_name = "app",
        use_go_frontend = true,
        gccgo_optimize = false,
        cgo_enabled = "1",
        ldflags = "",
        tags = {},
        setup_description = "Download Go module dependencies (gccgo debug)",
        compile_description = "Build with gccgo (debug)",
        bundle_description = "Verify gccgo debug artifacts",
        test_description = "Run tests with gccgo (verbose)",
        test_args = "-v -count=1",
        test_packages = "./...",
    },
}

M.configure_step_profiles = {
    ["gccgo:configure"] = "code",
    ["gccgo:configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["gccgo:compile"] = "code",
    ["gccgo:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["gccgo:bundle"] = "code",
    ["gccgo:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["gccgo:test"] = "code",
    ["gccgo:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["gccgo:run"] = "code",
    ["gccgo:run:debug"] = "debug",
}

return M
