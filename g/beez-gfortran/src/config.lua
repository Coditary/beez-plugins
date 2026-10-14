local defaults = require("src.defaults")
local detect = require("src.detect")

local M = {}

local function copy_string_array(values, fallback)
    if values == nil then
        return fallback
    end

    if type(values) ~= "table" then
        error("gfortran array config fields must be tables of strings")
    end

    local copied = {}
    for _, entry in ipairs(values) do
        if type(entry) ~= "string" then
            error("gfortran array config entries must be strings")
        end
        copied[#copied + 1] = entry
    end

    return copied
end

function M.resolve(step_cfg, profile_name, ctx)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown gfortran profile: " .. tostring(profile_name))
    end

    local detected = detect.resolve(ctx, {
        project_root = cfg.project_root,
        cmake_lists = cfg.cmake_lists,
        makefile = cfg.makefile,
        targets = cfg.targets,
        test_targets = cfg.test_targets,
        output_name = cfg.output_name or profile.output_name,
        bin_dir = cfg.bin_dir or defaults.bin_dir,
    })

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.gfortran_binary or defaults.gfortran_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_mode = cfg.build_mode or profile.build_mode,
        gfortran_binary = cfg.gfortran_binary or defaults.gfortran_binary,
        project_root = detected.project_root,
        sources = detected.sources,
        cmake_lists = detected.cmake_lists,
        makefile = detected.makefile,
        targets = detected.targets,
        test_targets = detected.test_targets,
        bin_dir = detected.bin_dir,
        primary_output = detected.primary_output,
        build_kind = detected.build_kind,
        optimize = cfg.optimize ~= nil and cfg.optimize or profile.optimize,
        debug_info = cfg.debug_info ~= nil and cfg.debug_info or profile.debug_info,
        gfortran_flags = copy_string_array(cfg.gfortran_flags, {}),
        setup_description = profile.setup_description,
        compile_description = profile.compile_description,
        bundle_description = profile.bundle_description,
        test_description = profile.test_description,
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
        parallelism = cfg.parallelism or beez.env_or("GFORTRAN_PARALLEL", "4"),
    }
end

return M
