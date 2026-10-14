local M = {}

M.runnable = false

M.build_dir = "build/chisel"
M.bin_dir = M.build_dir .. "/bin"
M.classes_dir = M.build_dir .. "/classes"
M.reports_dir = "report"

M.sbt_binary = "sbt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[chisel-setup]"
M.log_prefix_compile = "[chisel-compile]"
M.log_prefix_bundle = "[chisel-bundle]"
M.log_prefix_test = "[chisel-test]"


M.common_inputs = {
    "build.sbt",
    "**/build.sbt",
    "**/*.scala",
}

M.build_profiles = {
    code = {
        scope = "chisel",
        output_name = "app",
        setup_description = "Verify sbt and resolve Chisel dependencies",
        compile_description = "Compile Chisel/Scala sources via sbt",
        bundle_description = "Verify Chisel build artifacts",
        test_description = "Run Chisel tests via sbt",
        test_args = "",
        sbt_compile_task = "compile",
        sbt_test_task = "test",
    },

    debug = {
        scope = "debug",
        output_name = "app",
        setup_description = "Verify sbt (debug profile)",
        compile_description = "Compile Chisel/Scala sources (debug)",
        bundle_description = "Verify Chisel debug artifacts",
        test_description = "Run Chisel tests (verbose)",
        test_args = "-v",
        sbt_compile_task = "compile",
        sbt_test_task = "test",
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
