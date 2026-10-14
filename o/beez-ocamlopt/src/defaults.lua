local M = {}

M.runnable = true

M.build_dir = "build/ocamlopt"
M.obj_dir = M.build_dir .. "/obj"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ocamlopt_binary = "ocamlopt"
M.dune_binary = "dune"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ocamlopt-setup]"
M.log_prefix_compile = "[ocamlopt-compile]"
M.log_prefix_bundle = "[ocamlopt-bundle]"
M.log_prefix_test = "[ocamlopt-test]"

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
        scope = "native",
        build_mode = "release",
        output_name = "app",
        ocamlopt_args = {},
        setup_description = "Resolve OCaml native dependencies (dune or ocamlopt)",
        compile_description = "Compile OCaml sources to native code",
        bundle_description = "Verify OCaml native build artifacts",
        test_description = "Run OCaml native tests",
        test_args = "",
        dune_test_target = "runtest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        ocamlopt_args = { "-g" },
        setup_description = "Resolve OCaml native dependencies (debug)",
        compile_description = "Compile OCaml sources to native code (debug)",
        bundle_description = "Verify OCaml native debug artifacts",
        test_description = "Run OCaml native tests (verbose)",
        test_args = "--verbose",
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
