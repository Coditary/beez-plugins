local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown packagecompiler profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_toml = cfg.project_toml,
        project_root = cfg.project_root,
        project_name = cfg.project_name,
        entry_script = cfg.entry_script,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or profile.bin_dir or defaults.bin_dir,
        app_dir = cfg.app_dir or defaults.build_dir,
        sysimage_basename = cfg.sysimage_basename or profile.sysimage_basename,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.julia_binary or defaults.julia_binary,

        profile_name = profile_name,
        scope = profile.scope,
        compile_mode = cfg.compile_mode or profile.compile_mode,
        build_mode = cfg.build_mode or profile.build_mode,
        julia_binary = cfg.julia_binary or defaults.julia_binary,
        project_toml = detected.project_toml,
        project_root = detected.project_root,
        project_name = detected.project_name,
        entry_script = detected.entry_script,
        entry_script_rel = detected.entry_script_rel,
        module_name = detected.module_name,
        bin_dir = cfg.bin_dir or profile.bin_dir or detected.bin_dir,
        app_dir = detected.app_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        sysimage_basename = detected.sysimage_basename,
        force = cfg.force ~= nil and cfg.force or profile.force,
        julia_flags = cfg.julia_flags or profile.julia_flags or "",
        precompile_execution_file = cfg.precompile_execution_file,
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
        parallelism = cfg.parallelism or beez.env_or("JULIA_CPU_THREADS", "0"),
    }
end

return M
