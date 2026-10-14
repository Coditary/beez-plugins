local M = {}

M.runnable = true

M.build_dir = "build/godot"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.godot_binary = "godot"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[godot-setup]"
M.log_prefix_compile = "[godot-compile]"
M.log_prefix_bundle = "[godot-bundle]"
M.log_prefix_test = "[godot-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "project.godot",
    "**/project.godot",
    "**/*.gd",
}

M.build_profiles = {
    code = {
        scope = "godot",
        output_name = "main",
        setup_description = "Verify godot and import Godot project assets",
        compile_description = "Validate Godot with godot --headless --quit-after 1",
        bundle_description = "Verify godot compile stamp",
        test_description = "Run primary Godot via godot --headless --script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "godot",
        output_name = "main",
        setup_description = "Verify godot and import Godot project assets (debug)",
        compile_description = "Validate Godot with godot --headless --verbose (debug)",
        bundle_description = "Verify godot debug compile stamp",
        test_description = "Run primary Godot via godot --headless --script (verbose)",
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
