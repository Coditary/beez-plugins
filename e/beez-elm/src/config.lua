local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown elm profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        elm_json_path = cfg.elm_json_path,
        project_root = cfg.project_root,
        main_source = cfg.main_source,
        output_dir = cfg.output_dir or defaults.output_dir,
        output_name = cfg.output_name or profile.output_name,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.elm_binary or defaults.elm_binary,

        profile_name = profile_name,
        scope = profile.scope,
        optimize = cfg.optimize ~= nil and cfg.optimize or profile.optimize,
        elm_binary = cfg.elm_binary or defaults.elm_binary,
        elm_test_binary = cfg.elm_test_binary or defaults.elm_test_binary,
        elm_test_rs_binary = cfg.elm_test_rs_binary or defaults.elm_test_rs_binary,
        elm_json_path = detected.elm_json_path,
        has_elm_json = detected.has_elm_json,
        project_root = detected.project_root,
        main_source = detected.main_source,
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
