local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown ahk profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        entry_source = cfg.entry_source,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
        has_tests = cfg.has_tests,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.wine_binary or defaults.wine_binary,

        profile_name = profile_name,
        scope = profile.scope,
        wine_binary = cfg.wine_binary or beez.env_or("WINE", defaults.wine_binary),
        wine_prefix = cfg.wine_prefix or beez.env_or("WINEPREFIX", ""),
        ahk_binary = cfg.ahk_binary or beez.env_or("AHK_BINARY", defaults.ahk_binary),
        ahk2exe_binary = cfg.ahk2exe_binary or beez.env_or("AHK2EXE_BINARY", defaults.ahk2exe_binary),
        project_root = detected.project_root,
        entry_source = detected.entry_source,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        compile_stamp = detected.bin_dir .. "/.ahk-compile-" .. profile_name,
        compile_args = cfg.compile_args or profile.compile_args,
        has_tests = detected.has_tests,
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
