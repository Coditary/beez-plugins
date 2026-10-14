local M = {}

M.runnable = false

M.build_dir = "build/plantuml"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.plantuml_binary = "plantuml"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[plantuml-setup]"
M.log_prefix_compile = "[plantuml-compile]"
M.log_prefix_bundle = "[plantuml-bundle]"
M.log_prefix_test = "[plantuml-test]"


M.common_inputs = {
    "**/*.puml",
    "**/*.plantuml",
}

M.build_profiles = {
    code = {
        scope = "plantuml",
        output_name = "app.png",
        output_format = "png",
        setup_description = "Verify PlantUML diagram compiler",
        compile_description = "Render PlantUML diagram to PNG",
        bundle_description = "Verify PlantUML build artifacts",
        test_description = "Validate PlantUML sources",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "app.png",
        output_format = "png",
        setup_description = "Verify PlantUML compiler (debug)",
        compile_description = "Render PlantUML diagram to PNG (debug)",
        bundle_description = "Verify PlantUML debug artifacts",
        test_description = "Validate PlantUML sources (verbose)",
        test_args = "-verbose",
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
