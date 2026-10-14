local M = {}

M.runnable = false

M.build_dir = "build/doxygen"
M.bin_dir = M.build_dir .. "/html"
M.reports_dir = "report"

M.doxygen_binary = "doxygen"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[doxygen-setup]"
M.log_prefix_compile = "[doxygen-compile]"
M.log_prefix_bundle = "[doxygen-bundle]"
M.log_prefix_test = "[doxygen-test]"


M.common_inputs = {
    "Doxyfile",
    "**/*.c",
    "**/*.cpp",
    "**/*.h",
    "**/*.hpp",
    "**/*.go",
}

M.build_profiles = {
    code = {
        scope = "doxygen",
        output_name = "index.html",
        setup_description = "Verify Doxygen API documentation generator",
        compile_description = "Generate Doxygen HTML API documentation",
        bundle_description = "Verify Doxygen HTML build artifacts",
        test_description = "Validate Doxygen configuration with doxygen -s -",
        compile_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "index.html",
        setup_description = "Verify Doxygen API documentation generator (debug)",
        compile_description = "Generate Doxygen HTML API documentation (verbose)",
        bundle_description = "Verify Doxygen debug build artifacts",
        test_description = "Validate Doxygen configuration (verbose)",
        compile_args = "",
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
