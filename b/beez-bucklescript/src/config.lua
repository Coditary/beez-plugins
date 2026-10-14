local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown bucklescript profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        bsconfig_path = cfg.bsconfig_path,
        package_json_path = cfg.package_json_path,
        project_root = cfg.project_root,
        package_name = cfg.package_name,
        js_dir = cfg.js_dir or defaults.js_dir,
        bs_dir = cfg.bs_dir or defaults.bs_dir,
        sources = cfg.sources,
        use_native = cfg.use_native,
    })

    local use_native = cfg.use_native
    if use_native == nil then
        use_native = profile.use_native or detected.use_native
    end

    local bsb_binary = cfg.bsb_binary or defaults.bsb_binary
    if use_native then
        bsb_binary = cfg.bsb_native_binary or defaults.bsb_native_binary
    end

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.bsb_binary or defaults.bsb_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        bsb_binary = bsb_binary,
        npm_binary = cfg.npm_binary or defaults.npm_binary,
        bsconfig_path = detected.bsconfig_path,
        package_json_path = detected.package_json_path,
        has_package_json = detected.has_package_json,
        has_bsconfig = detected.has_bsconfig,
        project_root = detected.project_root,
        package_name = detected.package_name,
        sources = detected.sources,
        js_dir = detected.js_dir,
        bs_dir = detected.bs_dir,
        use_native = use_native,
        primary_source = detected.primary_source,
        bsb_args = cfg.bsb_args or profile.bsb_args,
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
