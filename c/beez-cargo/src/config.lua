local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("cargo array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("cargo array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown cargo profile: " .. tostring(profile_name))
    end

    local bin_dir = cfg.bin_dir or profile.bin_dir
    local detected = detect.resolve(ctx, {
        cargo_toml = cfg.cargo_toml,
        workspace_root = cfg.workspace_root,
        package_name = cfg.package_name,
        bin_dir = bin_dir,
        binary_names = cfg.binary_names,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.cargo_binary or defaults.cargo_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        cargo_binary = cfg.cargo_binary or defaults.cargo_binary,
        cargo_toml = detected.cargo_toml,
        workspace_root = detected.workspace_root,
        binary_names = detected.binary_names,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        cargo_profile = cfg.cargo_profile or profile.cargo_profile,
        target_dir = cfg.target_dir or profile.target_dir,
        extra_args = copy_string_array(cfg.extra_args, profile.extra_args),
        test_args = cfg.test_args or profile.test_args,
        test_packages = cfg.test_packages or profile.test_packages,
        use_llvm_cov = cfg.use_llvm_cov ~= nil and cfg.use_llvm_cov or profile.use_llvm_cov,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
