local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("oxygene array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("oxygene array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown oxygene profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        toolchain = cfg.toolchain,
        elements = cfg.elements,
        oxygene = cfg.oxygene,
        project_file = cfg.project_file,
        project_root = cfg.project_root,
        source_files = cfg.source_files,
        test_elements = cfg.test_elements,
        output_name = cfg.output_name or profile.output_name,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        obj_dir = cfg.obj_dir or defaults.obj_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.msbuild_binary or defaults.msbuild_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        toolchain = detected.toolchain,
        elements_binary = cfg.elements_binary or defaults.elements_binary,
        msbuild_binary = cfg.msbuild_binary or defaults.msbuild_binary,
        project_file = detected.project_file,
        project_root = detected.project_root,
        project_kind = detected.project_kind,
        source_files = detected.source_files,
        build_dir = detected.build_dir,
        bin_dir = detected.bin_dir,
        obj_dir = detected.obj_dir,
        primary_output = detected.primary_output,
        output_name = detected.output_name,
        test_elements = detected.test_elements,
        configuration = cfg.configuration or profile.configuration,
        platform = cfg.platform or profile.platform,
        elements_target = cfg.elements_target,
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
