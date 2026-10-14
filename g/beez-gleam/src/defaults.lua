local M = {}

M.runnable = true

M.build_dir = "build/gleam"
M.ebin_dir = M.build_dir .. "/ebin"
M.reports_dir = "report"

M.gleam_binary = "gleam"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gleam-setup]"
M.log_prefix_compile = "[gleam-compile]"
M.log_prefix_bundle = "[gleam-bundle]"
M.log_prefix_test = "[gleam-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "gleam.toml",
    "manifest.toml",
    "src/**/*.gleam",
    "test/**/*.gleam",
    "**/*.gleam",
}

M.build_profiles = {
    code = {
        scope = "gleam",
        build_mode = "release",
        build_target = "erlang",
        build_mode_flag = "",
        setup_description = "Resolve Gleam dependencies (gleam deps download)",
        compile_description = "Compile Gleam sources to BEAM bytecode (gleam build)",
        bundle_description = "Verify Gleam build artifacts",
        test_description = "Run Gleam tests (gleam test)",
        test_args = "",
        build_args = {},
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        build_target = "erlang",
        build_mode_flag = "",
        setup_description = "Resolve Gleam dependencies (debug)",
        compile_description = "Compile Gleam sources to BEAM bytecode (debug)",
        bundle_description = "Verify Gleam debug artifacts",
        test_description = "Run Gleam tests (verbose)",
        test_args = "",
        build_args = {},
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
