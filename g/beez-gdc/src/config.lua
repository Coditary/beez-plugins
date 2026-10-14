local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("gdc array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("gdc array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown gdc profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        dub_manifest = cfg.dub_manifest,
        project_root = cfg.project_root,
        targets = cfg.targets,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.gdc_binary or defaults.gdc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        gdc_binary = cfg.gdc_binary or defaults.gdc_binary,
        dub_binary = cfg.dub_binary or defaults.dub_binary,
        dub_manifest = detected.dub_manifest,
        project_root = detected.project_root,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        uses_dub = detected.uses_dub,
        optimize = cfg.optimize ~= nil and cfg.optimize or profile.optimize,
        debug_symbols = cfg.debug_symbols ~= nil and cfg.debug_symbols or profile.debug_symbols,
        dub_build = cfg.dub_build or profile.dub_build,
        gdc_flags = copy_string_array(cfg.gdc_flags, profile.gdc_flags),
        dub_flags = copy_string_array(cfg.dub_flags, profile.dub_flags),
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
