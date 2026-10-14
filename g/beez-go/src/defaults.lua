local M = {}

M.runnable = true

M.build_dir = "build/go"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.go_binary = "go"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[go-setup]"
M.log_prefix_compile = "[go-compile]"
M.log_prefix_bundle = "[go-bundle]"
M.log_prefix_test = "[go-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "go.mod",
    "go.sum",
    "**/*.go",
}

M.build_profiles = {
    code = {
        scope = "app",
        build_mode = "release",
        output_name = "app",
        ldflags = "-s -w",
        trimpath = true,
        cgo_enabled = "0",
        gcflags = "",
        tags = {},
        setup_description = "Download Go module dependencies (gc)",
        compile_description = "Build with gc (official Go compiler)",
        bundle_description = "Verify gc build artifacts",
        test_description = "Run tests with gc",
        test_args = "-race -count=1",
        test_packages = "./...",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        ldflags = "",
        trimpath = false,
        cgo_enabled = "1",
        gcflags = "all=-N -l",
        tags = {},
        setup_description = "Download Go module dependencies (gc debug)",
        compile_description = "Build with gc (debug, no optimizations)",
        bundle_description = "Verify gc debug artifacts",
        test_description = "Run tests with gc (verbose)",
        test_args = "-v -count=1",
        test_packages = "./...",
    },

    coverage = {
        scope = "coverage",
        build_mode = "coverage",
        output_name = "app",
        ldflags = "",
        trimpath = false,
        cgo_enabled = "0",
        gcflags = "",
        tags = {},
        setup_description = "Download Go module dependencies (gc coverage)",
        compile_description = "Build with gc (coverage instrumentation)",
        bundle_description = "Verify gc coverage artifacts",
        test_description = "Run tests with gc coverage profile",
        test_args = "-coverprofile=report/test/go-coverage.out -covermode=atomic",
        test_packages = "./...",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
    ["configure:coverage"] = "coverage",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
    ["compile:coverage"] = "coverage",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
    ["bundle:coverage"] = "coverage",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
    ["test:coverage"] = "coverage",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:coverage"] = "coverage",
    ["run:debug"] = "debug",
}

return M
