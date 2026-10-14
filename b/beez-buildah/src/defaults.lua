local M = {}

M.runnable = false

M.build_dir = "build/buildah"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.buildah_binary = "buildah"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[buildah-setup]"
M.log_prefix_compile = "[buildah-compile]"
M.log_prefix_bundle = "[buildah-bundle]"
M.log_prefix_test = "[buildah-test]"


M.common_inputs = {
    "Containerfile",
    "Dockerfile",
    "**/Containerfile",
    "**/Dockerfile",
}

M.build_profiles = {
    code = {
        scope = "buildah",
        output_name = "image.ok",
        image_tag = "beez-build:latest",
        setup_description = "Verify Buildah CLI and container build context",
        compile_description = "Build OCI container image with Buildah",
        bundle_description = "Verify Buildah container image artifacts",
        test_description = "Inspect built container image metadata",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "image.ok",
        image_tag = "beez-build:debug",
        setup_description = "Verify Buildah CLI (debug)",
        compile_description = "Build container image with verbose output (debug)",
        bundle_description = "Verify Buildah debug image artifacts",
        test_description = "Inspect container image (verbose)",
        test_args = "--debug",
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
