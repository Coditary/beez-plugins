local M = {}

M.runnable = true

M.build_dir = "build/clojureclr"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.clojure_compile_binary = "clojure.compile"
M.dotnet_binary = "dotnet"
M.clojure_binary = "clojure"
M.lein_binary = "lein"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[clojureclr-setup]"
M.log_prefix_compile = "[clojureclr-compile]"
M.log_prefix_bundle = "[clojureclr-bundle]"
M.log_prefix_test = "[clojureclr-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "project.clj",
    "**/project.clj",
    "deps.edn",
    "**/deps.edn",
    "*.csproj",
    "**/*.csproj",
    "*.sln",
    "**/*.sln",
    "**/*.clj",
}

M.build_profiles = {
    code = {
        scope = "clojureclr",
        build_mode = "release",
        configuration = "Release",
        output_name = "app",
        extra_args = {},
        setup_description = "Resolve ClojureCLR dependencies",
        compile_description = "Compile ClojureCLR project (Release)",
        bundle_description = "Verify ClojureCLR build artifacts",
        test_description = "Run ClojureCLR tests",
        test_args = "",
        test_filter = "",
    },

    debug = {
        scope = "clojureclr",
        build_mode = "debug",
        configuration = "Debug",
        output_name = "app",
        extra_args = {},
        setup_description = "Resolve ClojureCLR dependencies (debug)",
        compile_description = "Compile ClojureCLR project (Debug)",
        bundle_description = "Verify ClojureCLR debug artifacts",
        test_description = "Run ClojureCLR tests (verbose)",
        test_args = "--verbosity normal",
        test_filter = "",
    },

    coverage = {
        scope = "clojureclr",
        build_mode = "coverage",
        configuration = "Debug",
        output_name = "app",
        extra_args = {},
        setup_description = "Resolve ClojureCLR dependencies (coverage)",
        compile_description = "Compile ClojureCLR project for coverage",
        bundle_description = "Verify ClojureCLR coverage artifacts",
        test_description = "Run ClojureCLR tests with coverage collection",
        test_args = "--collect:"XPlat Code Coverage"",
        test_filter = "",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
    ["configure:coverage"] = "coverage",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
    ["compile:coverage"] = "coverage",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
    ["bundle:coverage"] = "coverage",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
    ["test:coverage"] = "coverage",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:coverage"] = "coverage",
    ["run:debug"] = "debug",
}

return M
