local M = {}

M.runnable = true

M.build_dir = "build/racket"
M.bin_dir = M.build_dir .. "/compiled"
M.reports_dir = "report"

M.racket_binary = "racket"
M.raco_binary = "raco"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[racket-setup]"
M.log_prefix_compile = "[racket-compile]"
M.log_prefix_bundle = "[racket-bundle]"
M.log_prefix_test = "[racket-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "info.rkt",
    "**/info.rkt",
    "**/*.rkt",
}

M.build_profiles = {
    code = {
        scope = "racket",
        build_mode = "release",
        output_name = "app",
        setup_description = "Install Racket package dependencies (raco pkg install)",
        compile_description = "Compile Racket modules with raco make",
        bundle_description = "Verify Racket compiled artifacts",
        test_description = "Run Racket tests with raco test",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "racket",
        build_mode = "debug",
        output_name = "app",
        setup_description = "Install Racket package dependencies (debug)",
        compile_description = "Compile Racket modules with raco make (debug)",
        bundle_description = "Verify Racket debug compiled artifacts",
        test_description = "Run Racket tests with raco test (verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
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
