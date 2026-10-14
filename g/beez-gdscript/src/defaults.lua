local M = {}

M.runnable = true

M.build_dir = "build/gdscript"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.godot_binary = "godot"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[gdscript-setup]"
M.log_prefix_compile = "[gdscript-compile]"
M.log_prefix_bundle = "[gdscript-bundle]"
M.log_prefix_test = "[gdscript-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "project.godot",
    "**/project.godot",
    "**/*.gd",
}

M.build_profiles = {
    code = {
        scope = "gdscript",
        output_name = "main",
        setup_description = "Verify godot and import Godot project assets",
        compile_description = "Validate GDScript with godot --headless --quit-after 1",
        bundle_description = "Verify gdscript compile stamp",
        test_description = "Run primary GDScript via godot --headless --script",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "gdscript",
        output_name = "main",
        setup_description = "Verify godot and import Godot project assets (debug)",
        compile_description = "Validate GDScript with godot --headless --verbose (debug)",
        bundle_description = "Verify gdscript debug compile stamp",
        test_description = "Run primary GDScript via godot --headless --script (verbose)",
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
