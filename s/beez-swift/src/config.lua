local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("swift array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("swift array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown swift profile: " .. tostring(profile_name))
    end

    local bin_dir = cfg.bin_dir or profile.bin_dir
    local detected = detect.resolve(ctx, {
        package_swift = cfg.package_swift,
        package_root = cfg.package_root,
        package_name = cfg.package_name,
        bin_dir = bin_dir,
        executable_names = cfg.executable_names,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.swift_binary or defaults.swift_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        swift_binary = cfg.swift_binary or defaults.swift_binary,
        swiftc_binary = cfg.swiftc_binary or defaults.swiftc_binary,
        package_swift = detected.package_swift,
        package_root = detected.package_root,
        executable_names = detected.executable_names,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        build_path = cfg.build_path or profile.build_path,
        configuration = cfg.configuration or profile.configuration,
        extra_args = copy_string_array(cfg.extra_args, profile.extra_args),
        test_args = cfg.test_args or profile.test_args,
        test_filter = cfg.test_filter or profile.test_filter,
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
