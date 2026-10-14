local M = {}

M.runnable = false

M.build_dir = "build/spark"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.spark_binary = "gnatprove"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[spark-setup]"
M.log_prefix_compile = "[spark-compile]"
M.log_prefix_bundle = "[spark-bundle]"
M.log_prefix_test = "[spark-test]"


M.common_inputs = {
    "**/*.ads",
    "**/*.adb",
    "*.spark",
    "**/*.spark",
}

M.build_profiles = {
    code = {
        scope = "spark",
        output_name = "app",
        compile_flag = "",
        setup_description = "Verify gnatprove and prepare build directory",
        compile_description = "Compile spark sources (gnatprove)",
        bundle_description = "Verify spark compile artifacts",
        test_description = "Verify spark build output",
        test_args = "",
    },

    debug = {
        scope = "spark",
        output_name = "app",
        compile_flag = "--debug",
        setup_description = "Verify gnatprove and prepare build directory (debug)",
        compile_description = "Compile spark sources with debug flags",
        bundle_description = "Verify spark debug compile artifacts",
        test_description = "Verify spark debug build output",
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
