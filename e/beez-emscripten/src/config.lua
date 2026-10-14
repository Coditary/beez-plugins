local defaults = require("src.defaults")

local M = {}

function M.resolve_build_tree(profile, step_cfg)
    if step_cfg.build_tree ~= nil then
        return step_cfg.build_tree
    end

    if profile.build_tree ~= nil then
        return profile.build_tree
    end

    return defaults.build_tree
end

function M.resolve(step_cfg, profile_name, root)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown emscripten profile: " .. tostring(profile_name))
    end

    local build_tree = M.resolve_build_tree(profile, cfg)

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.python_binary or defaults.python_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_tree = build_tree,
        build_tree_abs = root .. "/" .. build_tree,
        index_lua = build_tree .. "/" .. defaults.index_file,
        index_lua_abs = root .. "/" .. build_tree .. "/" .. defaults.index_file,
        index_script = cfg.index_script or defaults.index_script,
        python_binary = cfg.python_binary or defaults.python_binary,
        cxx = cfg.cxx or beez.env_or("CXX", defaults.cxx),
        cc = cfg.cc or beez.env_or("CC", defaults.cc),
        compile_opt = cfg.compile_opt or profile.compile_opt or defaults.compile_opt,
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or cfg.log_prefix or defaults.log_prefix_compile,
        log_prefix_bundle = cfg.log_prefix_bundle or defaults.log_prefix_bundle,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        bundle_rev = cfg.bundle_rev or defaults.bundle_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
        ctest_args = cfg.ctest_args or profile.ctest_args,
        reports_dir = cfg.reports_dir or beez.env_or("REPORTS_DIR", defaults.reports_dir),
        parallelism = cfg.parallelism or 16,
        cache_key = cfg.cache_key or profile_name,
    }
end

return M
