local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown style-dictionary profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        package_json_path = cfg.package_json_path,
        config_path = cfg.config_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        dist_dir = cfg.dist_dir or defaults.dist_dir,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        style_dictionary_binary = cfg.style_dictionary_binary or defaults.style_dictionary_binary,
        npm_binary = cfg.npm_binary or defaults.npm_binary,
        npx_binary = cfg.npx_binary or defaults.npx_binary,
        package_json_path = detected.package_json_path,
        has_package_json = detected.has_package_json,
        config_path = detected.config_path,
        has_config = detected.has_config,
        has_tokens = detected.has_tokens,
        project_root = detected.project_root,
        dist_dir = detected.dist_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        test_args = cfg.test_args or profile.test_args,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        build_dir = cfg.build_dir or defaults.build_dir,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
