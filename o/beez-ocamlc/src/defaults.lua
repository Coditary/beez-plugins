local M = {}

M.runnable = true

M.build_dir = "build/ocamlc"
M.bytecode_dir = M.build_dir .. "/bytecode"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ocamlc_binary = "ocamlc"
M.dune_binary = "dune"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ocamlc-setup]"
M.log_prefix_compile = "[ocamlc-compile]"
M.log_prefix_bundle = "[ocamlc-bundle]"
M.log_prefix_test = "[ocamlc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dune-project",
    "dune",
    "**/dune-project",
    "**/dune",
    "lib/**/*.ml",
    "lib/**/*.mli",
    "src/**/*.ml",
    "src/**/*.mli",
    "bin/**/*.ml",
    "bin/**/*.mli",
    "**/*.ml",
    "**/*.mli",
}

M.build_profiles = {
    code = {
        scope = "bytecode",
        build_mode = "release",
        output_name = "app",
        ocamlc_args = {},
        setup_description = "Resolve OCaml bytecode dependencies (dune or ocamlc)",
        compile_description = "Compile OCaml sources to bytecode",
        bundle_description = "Verify OCaml bytecode build artifacts",
        test_description = "Run OCaml bytecode tests",
        test_args = "",
        dune_build_target = "@install",
        dune_test_target = "runtest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        ocamlc_args = { "-g" },
        setup_description = "Resolve OCaml bytecode dependencies (debug)",
        compile_description = "Compile OCaml sources to bytecode (debug)",
        bundle_description = "Verify OCaml bytecode debug artifacts",
        test_description = "Run OCaml bytecode tests (verbose)",
        test_args = "--verbose",
        dune_build_target = "@install",
        dune_test_target = "runtest",
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
