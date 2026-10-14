local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("ecj array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("ecj array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown ecj profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        manifest = cfg.manifest,
        pom_xml = cfg.pom_xml,
        build_gradle = cfg.build_gradle,
        project_type = cfg.project_type,
        project_root = cfg.project_root,
        source_roots = cfg.source_roots,
        output_name = cfg.output_name or profile.output_name,
        classes_dir = cfg.classes_dir or defaults.classes_dir,
        main_class = cfg.main_class,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.java_binary or defaults.java_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        ecj_binary = cfg.ecj_binary or defaults.ecj_binary,
        ecj_jar = cfg.ecj_jar or "",
        java_binary = cfg.java_binary or defaults.java_binary,
        maven_binary = cfg.maven_binary or defaults.maven_binary,
        gradle_binary = cfg.gradle_binary or defaults.gradle_binary,
        manifest = detected.manifest,
        project_type = detected.project_type,
        project_root = detected.project_root,
        source_roots = detected.source_roots,
        main_class = detected.main_class,
        classes_dir = detected.classes_dir,
        primary_output = detected.primary_output,
        classpath_file = cfg.classpath_file or (defaults.build_dir .. "/classpath.txt"),
        ecj_args = copy_string_array(cfg.ecj_args, profile.ecj_args),
        source_level = cfg.source_level or profile.source_level,
        target_level = cfg.target_level or profile.target_level,
        test_args = cfg.test_args or profile.test_args,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
    }
end

return M
