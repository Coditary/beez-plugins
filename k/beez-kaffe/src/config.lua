local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("kaffe array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("kaffe array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown kaffe profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        source_files = cfg.source_files,
        source_root = cfg.source_root,
        main_class = cfg.main_class,
        classes_dir = cfg.classes_dir or defaults.classes_dir,
        jar_path = cfg.jar_path or defaults.jar_path,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.kaffe_binary or defaults.kaffe_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        kaffe_binary = cfg.kaffe_binary or defaults.kaffe_binary,
        kaffec_binary = cfg.kaffec_binary or defaults.kaffec_binary,
        jar_binary = cfg.jar_binary or defaults.jar_binary,
        source_root = detected.source_root,
        main_sources = detected.main_sources,
        test_sources = detected.test_sources,
        test_classes = detected.test_classes,
        main_class = detected.main_class,
        classes_dir = detected.classes_dir,
        jar_path = detected.jar_path,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        compile_flags = copy_string_array(cfg.compile_flags, profile.compile_flags),
        classpath = cfg.classpath or "",
        test_classpath = cfg.test_classpath or cfg.classpath or "",
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
