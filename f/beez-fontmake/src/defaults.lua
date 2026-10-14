local M = {}

M.runnable = false

M.build_dir = "build/fontmake"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.fontmake_binary = "fontmake"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[fontmake-setup]"
M.log_prefix_compile = "[fontmake-compile]"
M.log_prefix_bundle = "[fontmake-bundle]"
M.log_prefix_test = "[fontmake-test]"


M.common_inputs = {
    "**/*.designspace",
    "**/*.ufo",
    "**/*.glyphs",
}

M.build_profiles = {
    code = {
        scope = "fontmake",
        output_formats = { "otf", "ttf" },
        output_name = "app.otf",
        setup_description = "Verify fontmake Python tool",
        compile_description = "Compile designspace/UFO/glyphs to OpenType/TTF",
        bundle_description = "Verify fontmake build artifacts",
        test_description = "Validate fontmake font compilation",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_formats = { "ttf" },
        output_name = "app.ttf",
        setup_description = "Verify fontmake Python tool (debug)",
        compile_description = "Compile designspace/UFO/glyphs to TTF (debug)",
        bundle_description = "Verify fontmake debug artifacts",
        test_description = "Validate fontmake font compilation (verbose)",
        compile_args = "-v",
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
