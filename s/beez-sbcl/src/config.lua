local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback or {}
    end

    if type(values) ~= "table" then
        error("sbcl array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("sbcl array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown sbcl profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        asd_file = cfg.asd_file,
        project_root = cfg.project_root,
        system_name = cfg.system_name,
        build_script = cfg.build_script,
        test_script = cfg.test_script,
        executables = cfg.executables,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.sbcl_binary or defaults.sbcl_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        sbcl_binary = cfg.sbcl_binary or defaults.sbcl_binary,
        asd_file = detected.asd_file,
        project_root = detected.project_root,
        system_name = detected.system_name,
        build_script = detected.build_script,
        test_script = detected.test_script,
        executables = detected.executables,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        artifact_globs = detected.artifact_globs,
        sbcl_options = cfg.sbcl_options or profile.sbcl_options,
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
        extra_args = copy_string_array(cfg.extra_args, {}),
    }
end

return M
