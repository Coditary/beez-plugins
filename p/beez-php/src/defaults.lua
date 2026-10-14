local M = {}

M.runnable = true

M.build_dir = "build/php"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.php_binary = "php"
M.composer_binary = "composer"
M.phpunit_binary = "phpunit"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[php-setup]"
M.log_prefix_compile = "[php-compile]"
M.log_prefix_bundle = "[php-bundle]"
M.log_prefix_test = "[php-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "composer.json",
    "**/composer.json",
    "**/*.php",
}

M.compile_exclude = [[/(\.git|vendor|build|node_modules|\.cache)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        setup_description = "Install PHP dependencies with Composer",
        compile_description = "Syntax-check and compile PHP sources with OPcache",
        bundle_description = "Verify PHP OPcache bytecode artifacts",
        test_description = "Run PHP tests with PHPUnit",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Install PHP dependencies with Composer (debug)",
        compile_description = "Syntax-check and compile PHP sources with OPcache (debug)",
        bundle_description = "Verify PHP OPcache debug bytecode artifacts",
        test_description = "Run PHP tests with PHPUnit (verbose)",
        test_args = "--verbose",
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
