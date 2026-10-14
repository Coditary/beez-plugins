local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("swc array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("swc array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown swc profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        swcrc_path = cfg.swcrc_path,
        package_json = cfg.package_json,
        project_root = cfg.project_root,
        source_dir = cfg.source_dir,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    local swc_binary = cfg.swc_binary or beez.env_or("SWC_BINARY", defaults.swc_binary)
    if swc_binary == "npx" then
        swc_binary = defaults.npx_swc_cli
    end

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.swc_binary or defaults.swc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        swc_binary = swc_binary,
        npm_binary = cfg.npm_binary or defaults.npm_binary,
        swcrc_path = detected.swcrc_path,
        package_json = detected.package_json,
        has_package_json = detected.has_package_json,
        project_root = detected.project_root,
        source_dir = detected.source_dir,
        build_dir = detected.build_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        source_maps = cfg.source_maps ~= nil and cfg.source_maps or profile.source_maps,
        extra_args = copy_string_array(cfg.extra_args, {}),
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
