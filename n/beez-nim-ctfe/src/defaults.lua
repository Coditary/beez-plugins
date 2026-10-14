local M = {}

M.runnable = true

M.build_dir = "build/nim-ctfe"
M.out_dir = M.build_dir .. "/out"
M.reports_dir = "report"

M.nim_binary = "nim"
M.nimble_binary = "nimble"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[nim-ctfe/setup]"
M.log_prefix_compile = "[nim-ctfe/compile]"
M.log_prefix_bundle = "[nim-ctfe/bundle]"
M.log_prefix_test = "[nim-ctfe/test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "**/*.nim",
}

M.build_profiles = {
    ctfe = {
        scope = "ctfe",
        setup_description = "Prepare Nim CTFE build directory and dependencies",
        compile_description = "Evaluate compile-time Nim code via NimVM (nim --eval / nim r)",
        bundle_description = "Verify Nim CTFE evaluation artifacts",
        test_description = "Run Nim CTFE and macro tests",
        test_args = "",
        nim_flags = {},
    },

    debug = {
        scope = "debug",
        setup_description = "Prepare Nim CTFE build directory (debug)",
        compile_description = "Evaluate compile-time Nim code with debug symbols (--opt:none)",
        bundle_description = "Verify Nim CTFE debug evaluation artifacts",
        test_description = "Run Nim CTFE and macro tests (verbose)",
        test_args = "--verbose",
        nim_flags = { "--opt:none", "--linedirs:on" },
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "ctfe",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["compile:code"] = "ctfe",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "ctfe",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "ctfe",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:code"] = "ctfe",
    ["run:debug"] = "debug",
}

return M
