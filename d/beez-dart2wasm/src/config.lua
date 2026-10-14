local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("dart2wasm array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("dart2wasm array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown dart2wasm profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        pubspec_path = cfg.pubspec_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name or profile.output_name,
        wasm_dir = cfg.wasm_dir or defaults.wasm_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.dart_binary or defaults.dart_binary,

        profile_name = profile_name,
        scope = profile.scope,
        compile_mode = cfg.compile_mode or profile.compile_mode,
        dart_binary = cfg.dart_binary or defaults.dart_binary,
        pubspec_path = detected.pubspec_path,
        has_pubspec = detected.has_pubspec,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        wasm_dir = detected.wasm_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        compile_args = copy_string_array(cfg.compile_args, profile.compile_args),
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
