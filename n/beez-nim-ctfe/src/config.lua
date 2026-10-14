local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("nim-ctfe array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("nim-ctfe array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown nim-ctfe profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        nimble_path = cfg.nimble_path,
        project_root = cfg.project_root,
        output_name = cfg.output_name,
        out_dir = cfg.out_dir or defaults.out_dir,
        targets = cfg.targets,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.nim_binary or defaults.nim_binary,

        profile_name = profile_name,
        scope = profile.scope,
        nim_binary = cfg.nim_binary or defaults.nim_binary,
        nimble_binary = cfg.nimble_binary or defaults.nimble_binary,
        nimble_path = detected.nimble_path,
        has_nimble = detected.has_nimble,
        project_root = detected.project_root,
        package_name = detected.package_name,
        targets = detected.targets,
        out_dir = detected.out_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        eval_snippet = cfg.eval_snippet or 'static: echo "nim-ctfe ok"',
        nim_flags = copy_string_array(cfg.nim_flags, profile.nim_flags or {}),
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
