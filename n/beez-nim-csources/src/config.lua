local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown nim-csources profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        csources_dir = cfg.csources_dir,
        build_nim_script = cfg.build_nim_script,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        nim_bootstrap_name = cfg.nim_bootstrap_name,
        nim_binary = cfg.nim_binary,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.cc_binary or defaults.cc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        release = cfg.release ~= nil and cfg.release or profile.release,
        boot_args = cfg.boot_args or profile.boot_args,
        cc_binary = cfg.cc_binary or beez.env_or("CC", defaults.cc_binary),
        nim_bootstrap_name = cfg.nim_bootstrap_name or defaults.nim_bootstrap_name,
        nim_binary = cfg.nim_binary or defaults.nim_binary,
        koch_binary = cfg.koch_binary or defaults.koch_binary,
        project_root = detected.project_root,
        csources_dir = detected.csources_dir,
        build_nim_script = detected.build_nim_script,
        has_koch = detected.has_koch,
        bin_dir = detected.bin_dir,
        bootstrap_nim = detected.bootstrap_nim,
        nim_output = detected.nim_output,
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
