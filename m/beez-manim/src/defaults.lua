local M = {}

M.runnable = false

M.build_dir = "build/manim"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.manim_binary = "manim"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[manim-setup]"
M.log_prefix_compile = "[manim-compile]"
M.log_prefix_bundle = "[manim-bundle]"
M.log_prefix_test = "[manim-test]"


M.common_inputs = {
    "**/*.py",
    "scenes/**",
}

M.build_profiles = {
    code = {
        scope = "manim",
        output_name = "app.mp4",
        setup_description = "Verify Manim mathematical animation compiler",
        compile_description = "Render Manim scene to MP4",
        bundle_description = "Verify Manim build artifacts",
        test_description = "Validate Manim scene sources",
        compile_args = "-ql",
        test_args = "-ql --dry_run",
    },

    debug = {
        scope = "debug",
        output_name = "app.mp4",
        setup_description = "Verify Manim compiler (debug)",
        compile_description = "Render Manim scene to MP4 (debug)",
        bundle_description = "Verify Manim debug artifacts",
        test_description = "Validate Manim scene sources (verbose)",
        compile_args = "-ql --verbosity DEBUG",
        test_args = "-ql --dry_run --verbosity DEBUG",
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


return M
