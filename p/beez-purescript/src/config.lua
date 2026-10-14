local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown purescript profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        spago_path = cfg.spago_path,
        package_json_path = cfg.package_json_path,
        project_root = cfg.project_root,
        output_dir = cfg.output_dir or defaults.output_dir,
        output_name = cfg.output_name or profile.output_name,
        purs_sources = cfg.purs_sources,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.spago_binary or defaults.spago_binary,

        profile_name = profile_name,
        scope = profile.scope,
        spago_binary = cfg.spago_binary or defaults.spago_binary,
        purs_binary = cfg.purs_binary or defaults.purs_binary,
        npm_binary = cfg.npm_binary or defaults.npm_binary,
        spago_path = detected.spago_path,
        has_spago = detected.has_spago,
        package_json_path = detected.package_json_path,
        has_package_json = detected.has_package_json,
        project_root = detected.project_root,
        purs_sources = detected.purs_sources,
        output_dir = detected.output_dir,
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
