local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("kotlin-js array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("kotlin-js array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown kotlin-js profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        backend = cfg.backend,
        gradle_build = cfg.gradle_build,
        gradlew = cfg.gradlew,
        project_root = cfg.project_root,
        sources = cfg.sources,
        output_name = cfg.output_name or profile.output_name,
        js_dir = cfg.js_dir or defaults.js_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.kotlinc_js_binary or defaults.kotlinc_js_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        backend = detected.backend,
        kotlinc_js_binary = cfg.kotlinc_js_binary or defaults.kotlinc_js_binary,
        gradle_binary = cfg.gradle_binary or defaults.gradle_binary,
        gradle_build = detected.gradle_build,
        gradlew = detected.gradlew,
        project_root = detected.project_root,
        sources = detected.sources,
        js_dir = detected.js_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        js_output = detected.js_output,
        kotlin_args = copy_string_array(cfg.kotlin_args, profile.kotlin_args),
        module_kind = cfg.module_kind or profile.module_kind,
        source_map = cfg.source_map ~= nil and cfg.source_map or profile.source_map,
        test_args = cfg.test_args or profile.test_args,
        gradle_compile_task = cfg.gradle_compile_task or profile.gradle_compile_task,
        gradle_test_task = cfg.gradle_test_task or profile.gradle_test_task,
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
