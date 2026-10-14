local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("mrustc array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("mrustc array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown mrustc profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        cargo_toml = cfg.cargo_toml,
        workspace_root = cfg.workspace_root,
        package_name = cfg.package_name,
        targets = cfg.targets,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.mrustc_binary or defaults.mrustc_binary,

        profile_name = profile_name,
        mrustc_binary = cfg.mrustc_binary or defaults.mrustc_binary,
        minicargo_binary = cfg.minicargo_binary or defaults.minicargo_binary,
        libstd_dir = cfg.libstd_dir or beez.env_or("MRUSTC_LIBSTD_DIR", ""),
        optimize = cfg.optimize ~= nil and cfg.optimize or profile.optimize,
        extra_args = copy_string_array(cfg.extra_args, profile.extra_args),
        test_args = cfg.test_args or profile.test_args,
        cargo_toml = detected.cargo_toml,
        workspace_root = detected.workspace_root,
        package_name = detected.package_name,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_source = detected.primary_source,
        build_dir = cfg.build_dir or defaults.build_dir,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
    }
end

return M
