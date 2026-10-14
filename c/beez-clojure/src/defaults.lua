local M = {}

M.runnable = true

M.build_dir = "build/clojure"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.clojure_binary = "clojure"
M.lein_binary = "lein"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[clojure-setup]"
M.log_prefix_compile = "[clojure-compile]"
M.log_prefix_bundle = "[clojure-bundle]"
M.log_prefix_test = "[clojure-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "deps.edn",
    "**/deps.edn",
    "project.clj",
    "**/project.clj",
    "**/*.clj",
    "**/*.cljc",
}

M.build_profiles = {
    code = {
        scope = "jvm",
        build_mode = "release",
        output_name = "app",
        build_alias = "build",
        test_alias = "test",
        setup_description = "Resolve JVM Clojure dependencies (clojure -P / lein deps)",
        compile_description = "Compile JVM Clojure project (clojure -M:build / lein compile)",
        bundle_description = "Verify JVM Clojure build artifacts",
        test_description = "Run JVM Clojure tests (clojure -M:test / lein test)",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "jvm",
        build_mode = "debug",
        output_name = "app",
        build_alias = "build",
        test_alias = "test",
        setup_description = "Resolve JVM Clojure dependencies (debug)",
        compile_description = "Compile JVM Clojure project (debug)",
        bundle_description = "Verify JVM Clojure debug artifacts",
        test_description = "Run JVM Clojure tests (verbose)",
        test_args = "--verbose",
        run_description = "Run application (debug)",
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
