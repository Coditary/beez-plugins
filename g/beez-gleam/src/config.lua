local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("gleam array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("gleam array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown gleam profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        gleam_toml = cfg.gleam_toml,
        project_root = cfg.project_root,
        sources = cfg.sources,
        ebin_dir = cfg.ebin_dir or defaults.ebin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.gleam_binary or defaults.gleam_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        build_target = cfg.build_target or profile.build_target,
        build_mode_flag = cfg.build_mode_flag or profile.build_mode_flag,
        gleam_binary = cfg.gleam_binary or defaults.gleam_binary,
        gleam_toml = detected.gleam_toml,
        project_root = detected.project_root,
        sources = detected.sources,
        ebin_dir = detected.ebin_dir,
        primary_output = detected.primary_output,
        build_args = copy_string_array(cfg.build_args, profile.build_args),
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
