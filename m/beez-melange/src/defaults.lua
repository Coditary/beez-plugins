local M = {}

M.runnable = true

M.build_dir = "build/melange"
M.js_dir = M.build_dir .. "/js"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.melange_binary = "melange"
M.dune_binary = "dune"
M.ocamlfind_binary = "ocamlfind"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[melange-setup]"
M.log_prefix_compile = "[melange-compile]"
M.log_prefix_bundle = "[melange-bundle]"
M.log_prefix_test = "[melange-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "dune-project",
    "dune",
    "**/dune",
    "melange.json",
    "**/melange.json",
    "src/**/*.ml",
    "src/**/*.mli",
    "src/**/*.re",
    "src/**/*.rei",
    "**/*.ml",
    "**/*.mli",
    "**/*.re",
    "**/*.rei",
    "*.opam",
    "**/*.opam",
}

M.build_profiles = {
    code = {
        scope = "melange",
        build_mode = "release",
        output_name = "main",
        melange_args = {},
        source_map = false,
        setup_description = "Resolve Melange dependencies (dune dry-run or opam deps)",
        compile_description = "Compile OCaml/Reason to JavaScript (dune build @melange)",
        bundle_description = "Verify Melange build artifacts",
        test_description = "Run Melange tests (dune runtest)",
        test_args = "",
        dune_profile = "release",
        dune_compile_target = "@melange",
        dune_test_target = "runtest",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "main",
        melange_args = { "--source-map" },
        source_map = true,
        setup_description = "Resolve Melange dependencies (debug)",
        compile_description = "Compile OCaml/Reason to JavaScript (debug profile, source maps)",
        bundle_description = "Verify Melange debug artifacts",
        test_description = "Run Melange tests (verbose)",
        test_args = "--verbose",
        dune_profile = "dev",
        dune_compile_target = "@melange",
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
