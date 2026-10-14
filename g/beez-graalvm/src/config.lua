local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("graalvm array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("graalvm array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown graalvm profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_marker = cfg.project_marker,
        project_root = cfg.project_root,
        build_tool = cfg.build_tool,
        use_gradle_wrapper = cfg.use_gradle_wrapper,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    local use_gradle_wrapper = detected.use_gradle_wrapper
    if use_gradle_wrapper == nil then
        use_gradle_wrapper = detect.has_gradle_wrapper(ctx, detected.project_root)
    end

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.native_image_binary or defaults.native_image_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        native_image_binary = cfg.native_image_binary or defaults.native_image_binary,
        maven_binary = cfg.maven_binary or defaults.maven_binary,
        gradle_binary = cfg.gradle_binary or defaults.gradle_binary,
        project_marker = detected.project_marker,
        project_root = detected.project_root,
        build_tool = detected.build_tool,
        use_gradle_wrapper = use_gradle_wrapper,
        bin_dir = detected.bin_dir,
        output_name = detected.output_name,
        primary_output = detected.primary_output,
        native_image_args = copy_string_array(cfg.native_image_args, profile.native_image_args),
        maven_package_args = cfg.maven_package_args or profile.maven_package_args,
        gradle_package_task = cfg.gradle_package_task or profile.gradle_package_task,
        maven_test_args = cfg.maven_test_args or profile.maven_test_args,
        gradle_test_task = cfg.gradle_test_task or profile.gradle_test_task,
        jar_path = cfg.jar_path,
        main_class = cfg.main_class,
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
        parallelism = cfg.parallelism or beez.env_or("GRAALVM_PARALLEL", "0"),
    }
end

return M
