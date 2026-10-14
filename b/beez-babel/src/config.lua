local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("babel array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("babel array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown babel profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        babel_config = cfg.babel_config,
        package_json = cfg.package_json,
        project_root = cfg.project_root,
        source_dirs = cfg.source_dirs,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.babel_binary or defaults.babel_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        babel_binary = cfg.babel_binary or defaults.babel_binary,
        npm_binary = cfg.npm_binary or defaults.npm_binary,
        use_npx = cfg.use_npx ~= nil and cfg.use_npx or defaults.use_npx,
        babel_config = detected.babel_config,
        package_json = detected.package_json,
        has_package_json = detected.has_package_json,
        project_root = detected.project_root,
        source_dirs = detected.source_dirs,
        ts_file_count = detected.ts_file_count,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        extensions = cfg.extensions or profile.extensions,
        presets = copy_string_array(cfg.presets, profile.presets),
        source_maps = cfg.source_maps ~= nil and cfg.source_maps or profile.source_maps,
        copy_files = cfg.copy_files ~= nil and cfg.copy_files or profile.copy_files,
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
