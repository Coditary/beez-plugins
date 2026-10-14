local M = {}

M.runnable = false

M.build_dir = "build/rpmbuild"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.rpmbuild_binary = "rpmbuild"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[rpmbuild-setup]"
M.log_prefix_compile = "[rpmbuild-compile]"
M.log_prefix_bundle = "[rpmbuild-bundle]"
M.log_prefix_test = "[rpmbuild-test]"


M.common_inputs = {
    "**/*.spec",
}

M.build_profiles = {
    code = {
        scope = "rpmbuild",
        output_name = "build.ok",
        rpm_output = "RPMS",
        setup_description = "Verify rpmbuild CLI and prepare RPM topdir",
        compile_description = "Build RPM packages from detected spec files",
        bundle_description = "Verify RPM build artifacts",
        test_description = "Validate RPM spec syntax and build output",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "build.ok",
        rpm_output = "RPMS-debug",
        setup_description = "Verify rpmbuild CLI (debug)",
        compile_description = "Build RPM packages with verbose output (debug)",
        bundle_description = "Verify RPM debug build artifacts",
        test_description = "Validate RPM spec syntax (verbose)",
        test_args = "-vv",
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
