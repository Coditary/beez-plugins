local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("delphi array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("delphi array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown delphi profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        toolchain = cfg.toolchain,
        dproj = cfg.dproj,
        dpr = cfg.dpr,
        project_file = cfg.project_file,
        project_root = cfg.project_root,
        test_dproj = cfg.test_dproj,
        output_name = cfg.output_name or profile.output_name,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        dcu_dir = cfg.dcu_dir or defaults.dcu_dir,
        delphi_binary = cfg.delphi_binary,
        delphi_binary_64 = cfg.delphi_binary_64 or defaults.delphi_binary_64,
        delphi_arch = cfg.delphi_arch,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.delphi_binary or defaults.delphi_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        toolchain = detected.toolchain,
        delphi_binary = detected.delphi_binary,
        msbuild_binary = cfg.msbuild_binary or defaults.msbuild_binary,
        project_file = detected.project_file,
        project_root = detected.project_root,
        project_kind = detected.project_kind,
        build_dir = detected.build_dir,
        bin_dir = detected.bin_dir,
        dcu_dir = detected.dcu_dir,
        primary_output = detected.primary_output,
        output_name = detected.output_name,
        test_dproj = detected.test_dproj,
        configuration = cfg.configuration or profile.configuration,
        platform = cfg.platform or profile.platform,
        extra_args = copy_string_array(cfg.extra_args, profile.extra_args),
        unit_paths = copy_string_array(cfg.unit_paths, profile.unit_paths),
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
