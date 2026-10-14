local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("beamasm array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("beamasm array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown beamasm profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        backend = cfg.backend,
        rebar_config = cfg.rebar_config,
        mix_exs = cfg.mix_exs,
        project_root = cfg.project_root,
        sources = cfg.sources,
        include_dirs = cfg.include_dirs,
        output_name = cfg.output_name or profile.output_name,
        ebin_dir = cfg.ebin_dir or defaults.ebin_dir,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.erlc_binary or defaults.erlc_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        backend = detected.backend,
        erlc_binary = cfg.erlc_binary or defaults.erlc_binary,
        erl_binary = cfg.erl_binary or defaults.erl_binary,
        rebar3_binary = cfg.rebar3_binary or defaults.rebar3_binary,
        mix_binary = cfg.mix_binary or defaults.mix_binary,
        rebar_config = detected.rebar_config,
        mix_exs = detected.mix_exs,
        project_root = detected.project_root,
        sources = detected.sources,
        include_dirs = detected.include_dirs,
        ebin_dir = detected.ebin_dir,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        launcher_output = detected.launcher_output,
        erlc_args = copy_string_array(cfg.erlc_args, profile.erlc_args),
        erl_args = cfg.erl_args or profile.erl_args,
        test_args = cfg.test_args or profile.test_args,
        rebar3_compile_task = cfg.rebar3_compile_task or profile.rebar3_compile_task,
        rebar3_test_task = cfg.rebar3_test_task or profile.rebar3_test_task,
        mix_compile_task = cfg.mix_compile_task or profile.mix_compile_task,
        mix_test_task = cfg.mix_test_task or profile.mix_test_task,
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
