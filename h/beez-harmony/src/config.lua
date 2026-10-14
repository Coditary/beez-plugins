local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown harmony profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        sources = cfg.sources,
        main_class = cfg.main_class,
        classes_dir = cfg.classes_dir or defaults.classes_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.java_binary or defaults.java_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        javac_binary = cfg.javac_binary or defaults.javac_binary,
        java_binary = cfg.java_binary or defaults.java_binary,
        maven_binary = cfg.maven_binary or defaults.maven_binary,
        gradle_binary = cfg.gradle_binary or defaults.gradle_binary,
        build_system = detected.build_system,
        project_root = detected.project_root,
        manifest = detected.manifest,
        sources = detected.sources,
        main_class = detected.main_class,
        classes_dir = detected.classes_dir,
        bin_dir = detected.bin_dir,
        gradle_command = detected.gradle_command,
        primary_output = detected.primary_output,
        javac_flags = cfg.javac_flags or profile.javac_flags,
        encoding = cfg.encoding or "UTF-8",
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
        parallelism = cfg.parallelism or beez.env_or("JAVA_PARALLEL", "0"),
    }
end

return M
