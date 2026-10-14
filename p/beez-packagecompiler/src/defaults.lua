local M = {}

M.runnable = true

M.build_dir = "build/packagecompiler"
M.bin_dir = M.build_dir .. "/bin"
M.debug_bin_dir = M.build_dir .. "/debug"
M.reports_dir = "report"

M.julia_binary = "julia"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[packagecompiler-setup]"
M.log_prefix_compile = "[packagecompiler-compile]"
M.log_prefix_bundle = "[packagecompiler-bundle]"
M.log_prefix_test = "[packagecompiler-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "Project.toml",
    "Manifest.toml",
    "**/*.jl",
}

M.build_profiles = {
    app = {
        scope = "aot",
        compile_mode = "create_app",
        build_mode = "release",
        output_name = "app",
        force = true,
        setup_description = "Instantiate Julia project and load PackageCompiler.jl",
        compile_description = "AOT compile Julia app via PackageCompiler.create_app",
        bundle_description = "Verify PackageCompiler create_app binary artifacts",
        test_description = "Run Julia package tests (Pkg.test)",
        test_args = "",
        run_description = "Run application (app)",
    },

    sysimage = {
        scope = "aot",
        compile_mode = "create_sysimage",
        build_mode = "release",
        output_name = "app",
        sysimage_basename = "sysimage",
        force = true,
        setup_description = "Instantiate Julia project and load PackageCompiler.jl",
        compile_description = "AOT compile Julia sysimage via PackageCompiler.create_sysimage",
        bundle_description = "Verify PackageCompiler create_sysimage artifacts",
        test_description = "Run Julia package tests (Pkg.test)",
        test_args = "",
        run_description = "Run application (sysimage)",
    },

    debug_app = {
        scope = "debug",
        compile_mode = "create_app",
        build_mode = "debug",
        output_name = "app",
        bin_dir = M.debug_bin_dir,
        force = true,
        julia_flags = "-g",
        setup_description = "Instantiate Julia project and load PackageCompiler.jl (debug)",
        compile_description = "AOT compile Julia app via PackageCompiler.create_app (debug, -g)",
        bundle_description = "Verify PackageCompiler debug create_app binary artifacts",
        test_description = "Run Julia package tests (Pkg.test, verbose)",
        test_args = "-v",
        run_description = "Run application (debug_app)",
    },

    debug_sysimage = {
        scope = "debug",
        compile_mode = "create_sysimage",
        build_mode = "debug",
        output_name = "app",
        bin_dir = M.debug_bin_dir,
        sysimage_basename = "sysimage",
        force = true,
        julia_flags = "-g",
        setup_description = "Instantiate Julia project and load PackageCompiler.jl (debug)",
        compile_description = "AOT compile Julia sysimage via PackageCompiler.create_sysimage (debug, -g)",
        bundle_description = "Verify PackageCompiler debug create_sysimage artifacts",
        test_description = "Run Julia package tests (Pkg.test, verbose)",
        test_args = "-v",
        run_description = "Run application (debug_sysimage)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "app",
    ["configure:debug"] = "debug_app",
}

M.compile_step_profiles = {
    ["compile:app"] = "app",
    ["compile:sysimage"] = "sysimage",
    ["compile:debug"] = "debug_app",
    ["compile:debug-sysimage"] = "debug_sysimage",
}

M.bundle_step_profiles = {
    ["bundle:app"] = "app",
    ["bundle:sysimage"] = "sysimage",
    ["bundle:debug"] = "debug_app",
    ["bundle:debug-sysimage"] = "debug_sysimage",
}

M.test_step_profiles = {
    ["test:unit"] = "app",
    ["test:debug"] = "debug_app",
}

M.run_step_profiles = {
    ["run:app"] = "app",
    ["run:debug"] = "debug_app",
    ["run:debug-sysimage"] = "debug_sysimage",
    ["run:sysimage"] = "sysimage",
}

return M
