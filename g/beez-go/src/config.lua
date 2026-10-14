local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("go array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("go array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

local function env_prefix(cfg)
    local parts = {
        "CGO_ENABLED=" .. beez.char.quote(cfg.cgo_enabled),
    }

    if cfg.parallelism ~= nil and cfg.parallelism ~= "" and cfg.parallelism ~= "0" then
        parts[#parts + 1] = "GOMAXPROCS=" .. beez.char.quote(cfg.parallelism)
    end

    return table.concat(parts, " ")
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown go profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        go_mod = cfg.go_mod,
        module_root = cfg.module_root,
        targets = cfg.targets,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    local resolved = {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.go_binary or defaults.go_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        go_binary = cfg.go_binary or defaults.go_binary,
        go_mod = detected.go_mod,
        module_root = detected.module_root,
        targets = detected.targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        primary_package = detected.primary_package,
        ldflags = cfg.ldflags or profile.ldflags,
        trimpath = cfg.trimpath ~= nil and cfg.trimpath or profile.trimpath,
        cgo_enabled = cfg.cgo_enabled or profile.cgo_enabled,
        gcflags = cfg.gcflags or profile.gcflags,
        tags = copy_string_array(cfg.tags, profile.tags),
        test_args = cfg.test_args or profile.test_args,
        test_packages = cfg.test_packages or profile.test_packages,
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
        parallelism = cfg.parallelism or beez.env_or("GO_PARALLEL", "0"),
    }

    resolved.env_prefix = env_prefix(resolved)
    return resolved
end

return M
