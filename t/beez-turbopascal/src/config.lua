local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown turbopascal profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        targets = cfg.targets,
        test_targets = cfg.test_targets,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.tpc_binary or defaults.tpc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        tpc_binary = cfg.tpc_binary or defaults.tpc_binary,
        run_binary = cfg.run_binary or beez.env_or("TPC_RUN", ""),
        project_root = detected.project_root,
        sources = detected.sources,
        targets = detected.targets,
        test_targets = detected.test_targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        tpc_args = cfg.tpc_args or profile.tpc_args,
        setup_description = profile.setup_description,
        compile_description = profile.compile_description,
        bundle_description = profile.bundle_description,
        test_description = profile.test_description,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        build_dir = cfg.build_dir or defaults.build_dir,
        obj_dir = cfg.obj_dir or defaults.obj_dir,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
