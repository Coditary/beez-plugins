local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown elixir profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        run_prefix = cfg.run_prefix or profile.run_prefix or "",
        interpreter_binary = cfg.interpreter_binary or cfg.elixir_binary or defaults.elixir_binary,
        profile_name = profile_name,
        scope = profile.scope,
        elixir_binary = cfg.elixir_binary or beez.env_or("ELIXIR", defaults.elixir_binary),
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        compile_stamp = detected.bin_dir .. "/.elixir-compile-" .. profile_name,
        primary_source = detected.primary_source,
        compile_exclude = cfg.compile_exclude or defaults.compile_exclude,
        test_args = cfg.test_args or profile.test_args,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        log_prefix_run = cfg.log_prefix_run or defaults.log_prefix_run,
        build_dir = cfg.build_dir or defaults.build_dir,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
        run_rev = cfg.run_rev or defaults.run_rev,
    }
end

return M
