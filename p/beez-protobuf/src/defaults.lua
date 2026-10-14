local M = {}

M.runnable = false

M.build_dir = "build/protobuf"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.protoc_binary = "protoc"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[protobuf-setup]"
M.log_prefix_compile = "[protobuf-compile]"
M.log_prefix_bundle = "[protobuf-bundle]"
M.log_prefix_test = "[protobuf-test]"


M.common_inputs = {
    "**/*.proto",
}

M.build_profiles = {
    code = {
        scope = "protobuf",
        output_name = "generate.ok",
        language = "cpp",
        setup_description = "Verify Google protoc compiler",
        compile_description = "Generate C++ code from Protocol Buffer definitions",
        bundle_description = "Verify protoc-generated artifacts",
        test_description = "Validate Protocol Buffer code generation",
        compile_args = "",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "generate.ok",
        language = "cpp",
        setup_description = "Verify Google protoc compiler (debug)",
        compile_description = "Generate C++ code with protoc debug output",
        bundle_description = "Verify protoc debug artifacts",
        test_description = "Validate Protocol Buffer code generation (verbose)",
        compile_args = "--error_format=msvs",
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
