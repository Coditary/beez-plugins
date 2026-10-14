local M = {}

M.runnable = false

M.build_dir = "build/prisma"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.prisma_binary = "npx prisma"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[prisma-setup]"
M.log_prefix_compile = "[prisma-compile]"
M.log_prefix_bundle = "[prisma-bundle]"
M.log_prefix_test = "[prisma-test]"


M.common_inputs = {
    "schema.prisma",
    "**/schema.prisma",
}

M.build_profiles = {
    code = {
        scope = "prisma",
        output_name = "generate.ok",
        setup_description = "Verify Prisma CLI and schema file",
        compile_description = "Generate Prisma Client from schema.prisma",
        bundle_description = "Verify Prisma generated client artifacts",
        test_description = "Validate Prisma schema syntax",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "generate.ok",
        setup_description = "Verify Prisma CLI (debug)",
        compile_description = "Generate Prisma Client with verbose output (debug)",
        bundle_description = "Verify Prisma debug generated artifacts",
        test_description = "Validate Prisma schema (verbose)",
        test_args = "--schema",
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
