local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown ldc profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        dub_manifest = cfg.dub_manifest,
        project_root = cfg.project_root,
        entry_point = cfg.entry_point,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.ldc_binary or defaults.ldc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        ldc_binary = cfg.ldc_binary or defaults.ldc_binary,
        dub_binary = cfg.dub_binary or defaults.dub_binary,
        dub_manifest = detected.dub_manifest,
        use_dub = detected.use_dub,
        project_root = detected.project_root,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_entry = detected.primary_entry,
        target_name = detected.target_name,
        ldc_flags = cfg.ldc_flags or profile.ldc_flags,
        dub_build = cfg.dub_build or profile.dub_build,
        dub_dflags = cfg.dub_dflags or profile.dub_dflags,
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
