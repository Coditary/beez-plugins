local M = {}

M.runnable = true

M.build_dir = "build/sbcl"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.sbcl_binary = "sbcl"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sbcl-setup]"
M.log_prefix_compile = "[sbcl-compile]"
M.log_prefix_bundle = "[sbcl-bundle]"
M.log_prefix_test = "[sbcl-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "*.asd",
    "**/*.asd",
    "**/*.lisp",
    "**/*.cl",
    "build.lisp",
    "build.cl",
    "build",
    "test.lisp",
    "test.cl",
}

M.build_profiles = {
    code = {
        scope = "sbcl",
        build_mode = "release",
        sbcl_options = "",
        setup_description = "Verify SBCL and prepare build directory",
        compile_description = "Build Common Lisp with SBCL (release)",
        bundle_description = "Verify SBCL build artifacts",
        test_description = "Run Common Lisp tests",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "sbcl",
        build_mode = "debug",
        sbcl_options = "--eval '(declaim (optimize (debug 3) (speed 0)))'",
        setup_description = "Verify SBCL and prepare build directory (debug)",
        compile_description = "Build Common Lisp with SBCL (debug)",
        bundle_description = "Verify SBCL debug artifacts",
        test_description = "Run Common Lisp tests (verbose)",
        test_args = "--eval '(setf *print-pretty* t)'",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "sbcl",
        build_mode = "coverage",
        sbcl_options = "--eval '(require :sb-sprof)'",
        setup_description = "Verify SBCL and prepare build directory (coverage)",
        compile_description = "Build Common Lisp with SBCL (profiling/coverage)",
        bundle_description = "Verify SBCL coverage artifacts",
        test_description = "Run Common Lisp tests with profiling",
        test_args = "",
        run_description = "Run application (coverage)",
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
