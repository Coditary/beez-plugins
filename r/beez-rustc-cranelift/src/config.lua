local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("rustc-cranelift array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("rustc-cranelift array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown rustc-cranelift profile: " .. tostring(profile_name))
    end

    local bin_dir = cfg.bin_dir or profile.bin_dir
    local detected = detect.resolve(ctx, {
        cargo_toml = cfg.cargo_toml,
        workspace_root = cfg.workspace_root,
        package_name = cfg.package_name,
        bin_dir = bin_dir,
        binary_names = cfg.binary_names,
    })

    local codegen_backend = cfg.codegen_backend or defaults.codegen_backend
    local cargo_profile = cfg.cargo_profile or profile.cargo_profile
    local profile_env_key = "CARGO_PROFILE_" .. string.upper(cargo_profile) .. "_CODEGEN_BACKEND"

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.cargo_binary or defaults.cargo_binary,

        profile_name = profile_name,
        build_mode = cfg.build_mode or profile.build_mode,
        cargo_binary = cfg.cargo_binary or defaults.cargo_binary,
        cargo_toml = detected.cargo_toml,
        workspace_root = detected.workspace_root,
        binary_names = detected.binary_names,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        cargo_profile = cargo_profile,
        target_dir = cfg.target_dir or profile.target_dir,
        codegen_backend = codegen_backend,
        extra_args = copy_string_array(cfg.extra_args, profile.extra_args),
        test_args = cfg.test_args or profile.test_args,
        test_packages = cfg.test_packages or profile.test_packages,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        env_prefix = profile_env_key .. "=" .. beez.char.quote(codegen_backend),
        rustflags = 'RUSTFLAGS="-C codegen-backend=' .. codegen_backend .. '"',
    }
end

return M
