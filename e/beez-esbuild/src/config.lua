local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown esbuild profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        package_json_path = cfg.package_json_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        dist_dir = cfg.dist_dir or defaults.dist_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.esbuild_binary or defaults.esbuild_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        esbuild_binary = cfg.esbuild_binary or defaults.esbuild_binary,
        npm_binary = cfg.npm_binary or defaults.npm_binary,
        package_json_path = detected.package_json_path,
        has_package_json = detected.has_package_json,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        dist_dir = detected.dist_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        esbuild_args = cfg.esbuild_args or profile.esbuild_args,
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
