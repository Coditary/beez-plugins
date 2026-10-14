local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("hhvm array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("hhvm array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown hhvm profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        composer_json = cfg.composer_json,
        hhconfig = cfg.hhconfig,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        entry_points = cfg.entry_points,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.hhvm_binary or defaults.hhvm_binary,

        profile_name = profile_name,
        scope = profile.scope,
        hhvm_binary = cfg.hhvm_binary or beez.env_or("HHVM", defaults.hhvm_binary),
        hhvm_autoload_binary = cfg.hhvm_autoload_binary or defaults.hhvm_autoload_binary,
        composer_binary = cfg.composer_binary or beez.env_or("COMPOSER", defaults.composer_binary),
        phpunit_binary = cfg.phpunit_binary or defaults.phpunit_binary,
        composer_json = detected.composer_json,
        hhconfig = detected.hhconfig,
        has_composer = detected.has_composer,
        has_hhconfig = detected.has_hhconfig,
        project_root = detected.project_root,
        package_name = detected.package_name,
        entry_points = detected.entry_points,
        build_dir = detected.build_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        extra_args = copy_string_array(cfg.extra_args, profile.extra_args),
        test_args = cfg.test_args or profile.test_args,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
