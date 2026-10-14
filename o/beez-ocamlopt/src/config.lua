local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("ocamlopt array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("ocamlopt array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown ocamlopt profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        backend = cfg.backend,
        dune_build = cfg.dune_build,
        project_root = cfg.project_root,
        package_name = cfg.package_name,
        sources = cfg.sources,
        output_name = cfg.output_name or profile.output_name,
        obj_dir = cfg.obj_dir or defaults.obj_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.ocamlopt_binary or defaults.ocamlopt_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        backend = detected.backend,
        ocamlopt_binary = cfg.ocamlopt_binary or defaults.ocamlopt_binary,
        dune_binary = cfg.dune_binary or defaults.dune_binary,
        dune_build = detected.dune_build,
        project_root = detected.project_root,
        package_name = detected.package_name,
        sources = detected.sources,
        main_source = detected.main_source,
        obj_dir = detected.obj_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        native_output = detected.native_output,
        ocamlopt_args = copy_string_array(cfg.ocamlopt_args, profile.ocamlopt_args),
        test_args = cfg.test_args or profile.test_args,
        dune_test_target = cfg.dune_test_target or profile.dune_test_target,
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
