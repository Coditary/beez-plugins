local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown clojure profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_clj = cfg.project_clj,
        deps_edn = cfg.deps_edn,
        project_root = cfg.project_root,
        source_files = cfg.source_files,
        output_name = cfg.output_name or profile.output_name,
        build_dir = cfg.build_dir or defaults.build_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.clojure_binary or defaults.clojure_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        clojure_binary = cfg.clojure_binary or beez.env_or("CLOJURE", defaults.clojure_binary),
        lein_binary = cfg.lein_binary or defaults.lein_binary,
        project_file = detected.project_file,
        project_root = detected.project_root,
        project_kind = detected.project_kind,
        source_files = detected.source_files,
        namespaces = cfg.namespaces or detected.namespaces,
        main_namespace = cfg.main_namespace,
        build_dir = detected.build_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        output_name = detected.output_name,
        build_alias = cfg.build_alias or profile.build_alias,
        test_alias = cfg.test_alias or profile.test_alias,
        test_args = cfg.test_args or profile.test_args,
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
