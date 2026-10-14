local M = {}

M.runnable = false

M.build_dir = "build/lilypond"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.lilypond_binary = "lilypond"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[lilypond-setup]"
M.log_prefix_compile = "[lilypond-compile]"
M.log_prefix_bundle = "[lilypond-bundle]"
M.log_prefix_test = "[lilypond-test]"


M.common_inputs = {
    "**/*.ly",
}

M.build_profiles = {
    code = {
        scope = "lilypond",
        output_name = "app.pdf",
        setup_description = "Verify LilyPond music notation compiler",
        compile_description = "Render LilyPond score to PDF",
        bundle_description = "Verify LilyPond build artifacts",
        test_description = "Validate LilyPond sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.pdf",
        setup_description = "Verify LilyPond compiler (debug)",
        compile_description = "Render LilyPond score to PDF (debug)",
        bundle_description = "Verify LilyPond debug artifacts",
        test_description = "Validate LilyPond sources (verbose)",
        test_args = "-v",
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
