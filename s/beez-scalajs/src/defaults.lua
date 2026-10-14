local M = {}

M.runnable = true

M.build_dir = "build/scalajs"
M.js_dir = M.build_dir .. "/js"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.scalajs_binary = "scalajs"
M.sbt_binary = "sbt"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[scalajs-setup]"
M.log_prefix_compile = "[scalajs-compile]"
M.log_prefix_bundle = "[scalajs-bundle]"
M.log_prefix_test = "[scalajs-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "build.sbt",
    "project/build.properties",
    "project/plugins.sbt",
    "**/build.sbt",
    "src/**/*.scala",
    "**/*.scala",
}

M.build_profiles = {
    code = {
        scope = "js",
        build_mode = "release",
        output_name = "main",
        scala_args = {},
        source_map = false,
        setup_description = "Resolve Scala.js dependencies (sbt update or scalajs)",
        compile_description = "Transpile Scala sources to JavaScript (fullOptJS)",
        bundle_description = "Verify Scala.js build artifacts",
        test_description = "Run Scala.js tests",
        test_args = "",
        sbt_compile_task = "fullOptJS",
        sbt_test_task = "test",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "main",
        scala_args = { "-sourcemap" },
        source_map = true,
        setup_description = "Resolve Scala.js dependencies (debug)",
        compile_description = "Transpile Scala sources to JavaScript (fastOptJS, source maps)",
        bundle_description = "Verify Scala.js debug artifacts",
        test_description = "Run Scala.js tests (verbose)",
        test_args = "-v",
        sbt_compile_task = "fastOptJS",
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

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
