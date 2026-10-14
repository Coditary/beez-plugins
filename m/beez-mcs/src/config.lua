local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("mcs array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("mcs array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown mcs profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        csproj = cfg.csproj,
        project_root = cfg.project_root,
        sources = cfg.sources,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        mcs_binary = cfg.mcs_binary or defaults.mcs_binary,
        dmcs_binary = cfg.dmcs_binary or defaults.dmcs_binary,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.mcs_binary or defaults.mcs_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        compiler_binary = detected.compiler_binary,
        mcs_binary = cfg.mcs_binary or defaults.mcs_binary,
        dmcs_binary = cfg.dmcs_binary or defaults.dmcs_binary,
        mono_binary = cfg.mono_binary or defaults.mono_binary,
        test_runner = cfg.test_runner or defaults.test_runner,
        csproj = detected.csproj,
        test_csproj = detected.test_csproj,
        project_root = detected.project_root,
        meta = detected.meta,
        sources = detected.sources,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        test_output = detected.test_output,
        references = copy_string_array(cfg.references, {}),
        lib_dirs = copy_string_array(cfg.lib_dirs, {}),
        optimize = cfg.optimize ~= nil and cfg.optimize or profile.optimize,
        debug_symbols = cfg.debug_symbols ~= nil and cfg.debug_symbols or profile.debug_symbols,
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
        setup_description = profile.setup_description,
        compile_description = profile.compile_description,
        bundle_description = profile.bundle_description,
        test_description = profile.test_description,
    }
end

return M
