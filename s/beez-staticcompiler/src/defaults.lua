local M = {}

M.runnable = true

M.build_dir = "build/staticcompiler"
M.bin_dir = M.build_dir .. "/bin"
M.debug_bin_dir = M.build_dir .. "/debug"
M.reports_dir = "report"

M.julia_binary = "julia"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[staticcompiler-setup]"
M.log_prefix_compile = "[staticcompiler-compile]"
M.log_prefix_bundle = "[staticcompiler-bundle]"
M.log_prefix_test = "[staticcompiler-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Project.toml",
    "Manifest.toml",
    "**/*.jl",
}

M.build_profiles = {
    static = {
        scope = "static",
        compile_mode = "compile_executable",
        output_name = "app",
        entry_function = "main",
        arg_types = "()",
        setup_description = "Instantiate Julia project and load StaticCompiler.jl",
        compile_description = "Compile standalone Julia binary via StaticCompiler.compile_executable",
        bundle_description = "Verify StaticCompiler standalone binary artifacts",
        test_description = "Run Julia package tests (Pkg.test)",
        test_args = "",
        run_description = "Run application (static)",
    },

    shlib = {
        scope = "static",
        compile_mode = "compile_shlib",
        output_name = "app",
        entry_function = "main",
        arg_types = "()",
        shlib_basename = "libapp",
        setup_description = "Instantiate Julia project and load StaticCompiler.jl",
        compile_description = "Compile standalone Julia shared library via StaticCompiler.compile_shlib",
        bundle_description = "Verify StaticCompiler shared library artifacts",
        test_description = "Run Julia package tests (Pkg.test)",
        test_args = "",
        run_description = "Run application (shlib)",
    },

    debug = {
        scope = "debug",
        compile_mode = "compile_executable",
        output_name = "app",
        entry_function = "main",
        arg_types = "()",
        bin_dir = M.debug_bin_dir,
        julia_flags = "-g",
        setup_description = "Instantiate Julia project and load StaticCompiler.jl (debug)",
        compile_description = "Compile standalone Julia binary via StaticCompiler.compile_executable (debug, -g)",
        bundle_description = "Verify StaticCompiler debug standalone binary artifacts",
        test_description = "Run Julia package tests (Pkg.test, verbose)",
        test_args = "-v",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "static",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:static"] = "static",
    ["compile:shlib"] = "shlib",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:static"] = "static",
    ["bundle:shlib"] = "shlib",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "static",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:debug"] = "debug",
    ["run:shlib"] = "shlib",
    ["run:static"] = "static",
}

return M
