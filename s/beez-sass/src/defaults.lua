local M = {}

M.runnable = false

M.build_dir = "build/sass"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.sass_binary = "sass"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[sass-setup]"
M.log_prefix_compile = "[sass-compile]"
M.log_prefix_bundle = "[sass-bundle]"
M.log_prefix_test = "[sass-test]"


M.common_inputs = {
    "**/*.scss",
    "**/*.sass",
}

M.build_profiles = {
    code = {
        scope = "sass",
        style = "compressed",
        output_name = "app.css",
        setup_description = "Verify Sass/SCSS compiler",
        compile_description = "Compile SCSS/Sass to compressed CSS",
        bundle_description = "Verify Sass build artifacts",
        test_description = "Validate SCSS/Sass compilation",
        test_args = "",
    },

    debug = {
        scope = "debug",
        style = "expanded",
        output_name = "app.css",
        setup_description = "Verify Sass/SCSS compiler (debug)",
        compile_description = "Compile SCSS/Sass to expanded CSS",
        bundle_description = "Verify Sass debug artifacts",
        test_description = "Validate SCSS/Sass compilation (verbose)",
        test_args = "--verbose",
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
