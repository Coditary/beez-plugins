local M = {}

M.runnable = true

M.build_dir = "build/zig"
M.bin_dir = "zig-out/bin"
M.cache_dir = ".zig-cache"
M.reports_dir = "report"

M.zig_binary = "zig"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[zig-setup]"
M.log_prefix_compile = "[zig-compile]"
M.log_prefix_bundle = "[zig-bundle]"
M.log_prefix_test = "[zig-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.zig",
    "build.zig.zon",
    "src/main.zig",
    "src/*.zig",
    "src/**/*.zig",
}

M.build_profiles = {
    code = {
        scope = "zig",
        optimize = "ReleaseFast",
        setup_description = "Fetch Zig package dependencies",
        compile_description = "Build with Zig (ReleaseFast, LLVM backend)",
        bundle_description = "Verify Zig build artifacts",
        test_description = "Run Zig tests",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "zig",
        optimize = "Debug",
        setup_description = "Fetch Zig package dependencies (debug)",
        compile_description = "Build with Zig (Debug)",
        bundle_description = "Verify Zig debug artifacts",
        test_description = "Run Zig tests (debug)",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["zig:configure"] = "code",
    ["zig:configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["zig:compile"] = "code",
    ["zig:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["zig:bundle"] = "code",
    ["zig:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["zig:test"] = "code",
    ["zig:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["zig:run"] = "code",
    ["zig:run:debug"] = "debug",
}

return M
