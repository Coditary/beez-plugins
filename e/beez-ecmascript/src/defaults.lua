local M = {}

M.runnable = true

M.build_dir = "build/ecmascript"
M.dist_dir = M.build_dir .. "/dist"
M.reports_dir = "report"

M.node_binary = "node"
M.d8_binary = "d8"
M.js_engine = "node"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ecmascript-setup]"
M.log_prefix_compile = "[ecmascript-compile]"
M.log_prefix_bundle = "[ecmascript-bundle]"
M.log_prefix_test = "[ecmascript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.js",
}

M.build_profiles = {
    code = {
        scope = "ecmascript",
        build_mode = "release",
        setup_description = "Verify Node/V8 runtime and prepare build directory",
        compile_description = "Validate ECMAScript with node --check",
        bundle_description = "Verify ECMAScript build artifacts under build/ecmascript/",
        test_description = "Run primary JavaScript entry point",
        compile_args = "",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "ecmascript",
        build_mode = "debug",
        setup_description = "Verify Node/V8 runtime and prepare build directory (debug)",
        compile_description = "Validate ECMAScript with d8 --check (debug)",
        bundle_description = "Verify ECMAScript debug build artifacts",
        test_description = "Run primary JavaScript entry point (verbose)",
        js_engine = "d8",
        compile_args = "",
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
