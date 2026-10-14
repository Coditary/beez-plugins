local M = {}

M.runnable = true

M.build_dir = "build/js-of-ocaml"
M.js_dir = M.build_dir .. "/js"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.jsoo_binary = "js_of_ocaml"
M.dune_binary = "dune"
M.ocamlfind_binary = "ocamlfind"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[js-of-ocaml-setup]"
M.log_prefix_compile = "[js-of-ocaml-compile]"
M.log_prefix_bundle = "[js-of-ocaml-bundle]"
M.log_prefix_test = "[js-of-ocaml-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dune-project",
    "dune",
    "**/dune",
    "jsoo.config.mli",
    "**/jsoo.config.mli",
    "src/**/*.ml",
    "src/**/*.mli",
    "**/*.ml",
    "**/*.mli",
    "*.opam",
    "**/*.opam",
}

M.build_profiles = {
    code = {
        scope = "js",
        build_mode = "release",
        output_name = "main",
        jsoo_args = { "--opt", "3" },
        source_map = false,
        setup_description = "Resolve js-of-ocaml dependencies (dune dry-run or opam deps)",
        compile_description = "Transpile OCaml bytecode to JavaScript (dune release / js_of_ocaml)",
        bundle_description = "Verify js-of-ocaml build artifacts",
        test_description = "Run js-of-ocaml tests (dune runtest)",
        test_args = "",
        dune_profile = "release",
        dune_compile_target = "@all",
        dune_test_target = "runtest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "main",
        jsoo_args = { "--debuginfo" },
        source_map = true,
        setup_description = "Resolve js-of-ocaml dependencies (debug)",
        compile_description = "Transpile OCaml to JavaScript (debug profile, source maps)",
        bundle_description = "Verify js-of-ocaml debug artifacts",
        test_description = "Run js-of-ocaml tests (verbose)",
        test_args = "--verbose",
        dune_profile = "dev",
        dune_compile_target = "@all",
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
