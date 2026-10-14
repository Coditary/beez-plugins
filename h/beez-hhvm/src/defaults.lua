local M = {}

M.runnable = true

M.build_dir = "build/hhvm"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.hhvm_binary = "hhvm"
M.hhvm_autoload_binary = "hhvm-autoload"
M.composer_binary = "composer"
M.phpunit_binary = "phpunit"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[hhvm-setup]"
M.log_prefix_compile = "[hhvm-compile]"
M.log_prefix_bundle = "[hhvm-bundle]"
M.log_prefix_test = "[hhvm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "composer.json",
    "**/composer.json",
    ".hhconfig",
    "**/.hhconfig",
    "**/*.php",
    "**/*.hh",
}

M.build_profiles = {
    code = {
        scope = "hhvm",
        output_name = "app",
        extra_args = {},
        setup_description = "Install Composer dependencies and generate HHVM autoload map",
        compile_description = "Type-check PHP/Hack sources with HHVM (--check)",
        bundle_description = "Verify HHVM build artifacts",
        test_description = "Run PHP tests with HHVM (phpunit)",
        test_args = "",
    },

    debug = {
        scope = "hhvm",
        output_name = "app",
        extra_args = { "--verbose" },
        setup_description = "Install Composer dependencies and generate HHVM autoload map (debug)",
        compile_description = "Type-check PHP/Hack sources with HHVM (--check, verbose)",
        bundle_description = "Verify HHVM debug build artifacts",
        test_description = "Run PHP tests with HHVM (phpunit, verbose)",
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

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
