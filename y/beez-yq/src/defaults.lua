local M = {}

M.runnable = true

M.build_dir = "build/yq"
M.bin_dir = M.build_dir
M.reports_dir = "report"

M.yq_binary = "yq"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"
M.run_rev = "1"

M.log_prefix_setup = "[yq-setup]"
M.log_prefix_compile = "[yq-compile]"
M.log_prefix_bundle = "[yq-bundle]"
M.log_prefix_test = "[yq-test]"
M.log_prefix_run = "[yq-run]"

M.common_inputs = {
    "**/*.yq",
    "pipeline.yaml",
    "**/pipeline.yaml",
    ".gitlab-ci.yml",
    "**/.gitlab-ci.yml"
}

M.compile_exclude = [[/(\.git|build|\.venv|local)/]]

M.build_profiles = {
    code = {
        scope = "app",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {"eval", "-n", "-f"},
        setup_description = "Verify Yq runtime and prepare build directory",
        compile_description = "Validate Yq entry with yq",
        bundle_description = "Verify Yq compile stamp",
        test_description = "Run primary Yq entry",
        test_args = "",
        run_description = "Run Yq application",
    },
    debug = {
        scope = "debug",
        output_name = "app",
        run_args = "",
        run_prefix = "",
        run_tokens = {"eval", "-n", "-f"},
        setup_description = "Verify Yq runtime (debug)",
        compile_description = "Validate Yq entry with yq (debug)",
        bundle_description = "Verify Yq debug compile stamp",
        test_description = "Run primary Yq entry (verbose)",
        test_args = "",
        run_description = "Run Yq application (debug)",
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
