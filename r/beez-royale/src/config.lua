local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown royale profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        asconfig = cfg.asconfig,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
    })

    return {

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = detected.build_mode,
        compile_flags = cfg.compile_flags or profile.compile_flags,
        royale_target = cfg.royale_target or profile.royale_target,
        royale_binary = cfg.royale_binary or beez.env_or("ROYALE", defaults.royale_binary),
        asconfigc_binary = cfg.asconfigc_binary or beez.env_or("ASCONFIGC", defaults.asconfigc_binary),
        project_root = detected.project_root,
        package_name = detected.package_name,
        asconfig_path = detected.asconfig_path,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
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
