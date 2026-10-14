local M = {}

M.runnable = false

M.build_dir = "build/terraform"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.terraform_binary = "terraform"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[terraform-setup]"
M.log_prefix_compile = "[terraform-compile]"
M.log_prefix_bundle = "[terraform-bundle]"
M.log_prefix_test = "[terraform-test]"


M.common_inputs = {
    "**/*.tf",
    "terraform.tfvars",
}

M.build_profiles = {
    code = {
        scope = "terraform",
        output_name = "validate.ok",
        plan_output = "plan.tfplan",
        setup_description = "Verify Terraform CLI and initialize providers",
        compile_description = "Validate Terraform HCL and generate plan",
        bundle_description = "Verify Terraform plan artifacts",
        test_description = "Validate Terraform configuration and formatting",
        test_args = "",
    },

    debug = {
        scope = "debug",
        output_name = "validate.ok",
        plan_output = "plan-debug.tfplan",
        setup_description = "Verify Terraform CLI (debug)",
        compile_description = "Validate Terraform HCL with detailed plan (debug)",
        bundle_description = "Verify Terraform debug plan artifacts",
        test_description = "Validate Terraform configuration (verbose)",
        test_args = "-compact-warnings",
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
