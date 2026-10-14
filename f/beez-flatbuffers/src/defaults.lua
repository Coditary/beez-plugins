local M = {}

M.runnable = false

M.build_dir = "build/flatbuffers"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.flatc_binary = "flatc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[flatbuffers-setup]"
M.log_prefix_compile = "[flatbuffers-compile]"
M.log_prefix_bundle = "[flatbuffers-bundle]"
M.log_prefix_test = "[flatbuffers-test]"


M.common_inputs = {
    "**/*.fbs",
}

M.build_profiles = {
    code = {
        scope = "flatbuffers",
        output_name = "generate.ok",
        setup_description = "Verify flatc FlatBuffers compiler",
        compile_description = "Generate C++ headers from FlatBuffer schemas",
        bundle_description = "Verify flatc-generated artifacts",
        test_description = "Validate FlatBuffer schema compilation",
        compile_args = "--gen-object-api",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "generate.ok",
        setup_description = "Verify flatc FlatBuffers compiler (debug)",
        compile_description = "Generate C++ with flatc reflection and object API",
        bundle_description = "Verify flatc debug artifacts",
        test_description = "Validate FlatBuffer schema compilation (verbose)",
        compile_args = "--gen-object-api --gen-mutable",
        test_args = "--version",
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
