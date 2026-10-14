local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback or {}
    end

    if type(values) ~= "table" then
        error("yhc array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("yhc array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

local function resolve_compiler_binary(cfg)
    local compiler = cfg.compiler or beez.env_or("YHC_COMPILER", defaults.default_compiler)
    if compiler == "lhc" then
        return "lhc", cfg.lhc_binary or beez.env_or("LHC_BINARY", defaults.lhc_binary)
    end
    return "yhc", cfg.yhc_binary or defaults.yhc_binary
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown yhc profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        build_tool = cfg.build_tool,
        cabal_file = cfg.cabal_file,
        project_root = cfg.project_root,
        package_name = cfg.package_name,
        executables = cfg.executables,
        main_hs = cfg.main_hs,
        targets = cfg.targets,
        test_sources = cfg.test_sources,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    local compiler, compiler_binary = resolve_compiler_binary(cfg)

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.yhc_binary or defaults.yhc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        build_tool = detected.build_tool,
        compiler = compiler,
        compiler_binary = compiler_binary,
        yhc_binary = cfg.yhc_binary or defaults.yhc_binary,
        lhc_binary = cfg.lhc_binary or defaults.lhc_binary,
        cabal_file = detected.cabal_file,
        project_root = detected.project_root,
        package_name = detected.package_name,
        executables = detected.executables,
        main_hs = detected.main_hs,
        targets = detected.targets,
        test_sources = detected.test_sources,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        artifact_globs = detected.artifact_globs,
        compiler_flags = cfg.compiler_flags or profile.compiler_flags,
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
