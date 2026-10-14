local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown ent profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        ent_schema_dir = cfg.ent_schema_dir or profile.ent_schema_dir,
        ent_output_dir = cfg.ent_output_dir,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        go_binary = cfg.go_binary or beez.env_or("GO", defaults.go_binary),
        ent_binary = cfg.ent_binary or defaults.ent_binary,
        project_root = detected.project_root,
        go_mod = detected.go_mod,
        ent_schema_dir = detected.ent_schema_dir,
        ent_output_dir = detected.ent_output_dir,
        bin_dir = detected.bin_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        has_schema_files = detected.has_schema_files,
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
