local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback or {}
    end

    if type(values) ~= "table" then
        error("asterius array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("asterius array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown asterius profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        build_tool = cfg.build_tool,
        stack_yaml = cfg.stack_yaml,
        cabal_file = cfg.cabal_file,
        project_root = cfg.project_root,
        package_name = cfg.package_name,
        executables = cfg.executables,
        main_hs = cfg.main_hs,
        wasm_dir = cfg.wasm_dir or defaults.wasm_dir,
        pseudo_exe_dir = cfg.pseudo_exe_dir or defaults.pseudo_exe_dir,
        dist_dir = cfg.dist_dir or defaults.dist_dir,
    })

    if detected.build_tool == "ahc" and detected.main_hs == nil then
        error("asterius plugin: no stack.yaml, *.cabal, or Main.hs found — add a Haskell project or set build_tool in configure()")
    end

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.ahc_link_binary or defaults.ahc_link_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        build_tool = detected.build_tool,
        ahc_link_binary = cfg.ahc_link_binary or defaults.ahc_link_binary,
        ahc_cabal_binary = cfg.ahc_cabal_binary or defaults.ahc_cabal_binary,
        ahc_dist_binary = cfg.ahc_dist_binary or defaults.ahc_dist_binary,
        asterius_binary = cfg.asterius_binary or defaults.asterius_binary,
        stack_yaml = detected.stack_yaml,
        cabal_file = detected.cabal_file,
        project_root = detected.project_root,
        package_name = detected.package_name,
        executables = detected.executables,
        main_hs = detected.main_hs,
        wasm_dir = detected.wasm_dir,
        pseudo_exe_dir = detected.pseudo_exe_dir,
        dist_dir = detected.dist_dir,
        primary_output = detected.primary_output,
        artifact_globs = detected.artifact_globs,
        ahc_options = cfg.ahc_options or profile.ahc_options,
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
