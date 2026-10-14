local M = {}

M.runnable = false

M.build_dir = "build/ent"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.go_binary = "go"
M.ent_binary = "go run -mod=mod entgo.io/ent/cmd/ent"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ent-setup]"
M.log_prefix_compile = "[ent-compile]"
M.log_prefix_bundle = "[ent-bundle]"
M.log_prefix_test = "[ent-test]"


M.common_inputs = {
    "go.mod",
    "**/go.mod",
    "ent/schema/**/*.go",
    "**/ent/schema/**/*.go",
}

M.build_profiles = {
    code = {
        scope = "ent",
        output_name = "generate.ok",
        ent_schema_dir = "ent/schema",
        setup_description = "Verify Go toolchain and Ent schema sources",
        compile_description = "Generate Ent ORM code from ent/schema",
        bundle_description = "Verify Ent generated code artifacts",
        test_description = "Build and validate Ent generated packages",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "generate.ok",
        ent_schema_dir = "ent/schema",
        setup_description = "Verify Go toolchain (debug)",
        compile_description = "Generate Ent code with verbose output (debug)",
        bundle_description = "Verify Ent debug generated artifacts",
        test_description = "Build Ent packages (verbose)",
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
