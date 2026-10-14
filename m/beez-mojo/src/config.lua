local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown mojo profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        mojoproject_path = cfg.mojoproject_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
        include_paths = cfg.include_paths,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.mojo_binary or defaults.mojo_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        mojo_binary = cfg.mojo_binary or defaults.mojo_binary,
        magic_binary = cfg.magic_binary or defaults.magic_binary,
        mojoproject_path = detected.mojoproject_path,
        has_mojoproject = detected.has_mojoproject,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        include_paths = detected.include_paths,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        optimization_level = cfg.optimization_level or profile.optimization_level,
        debug_level = cfg.debug_level or profile.debug_level,
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
