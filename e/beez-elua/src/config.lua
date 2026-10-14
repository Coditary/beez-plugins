local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown elua profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        sconstruct = cfg.sconstruct,
        project_root = cfg.project_root,
        platform = cfg.platform,
        platform_data = cfg.platform_data,
        default_platform = cfg.default_platform or defaults.default_platform,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        app_scripts = cfg.app_scripts,
        elua_build_subdir = cfg.elua_build_subdir or defaults.elua_build_subdir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.lua_binary or defaults.lua_binary,

        profile_name = profile_name,
        scope = profile.scope,
        scons_binary = cfg.scons_binary or defaults.scons_binary,
        cross_gcc_binary = cfg.cross_gcc_binary or defaults.cross_gcc_binary,
        lua_binary = cfg.lua_binary or defaults.lua_binary,
        scons_extra_args = cfg.scons_extra_args or profile.scons_extra_args,
        project_root = detected.project_root,
        sconstruct = detected.sconstruct,
        platform_data = detected.platform_data,
        platform = detected.platform,
        bin_dir = detected.bin_dir,
        app_scripts = detected.app_scripts,
        primary_output = detected.primary_output,
        elua_build_subdir = detected.elua_build_subdir,
        output_name = cfg.output_name or profile.output_name,
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
