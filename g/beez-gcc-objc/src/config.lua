local defaults = require("src.defaults")

local M = {}

function M.resolve_build_tree(profile, step_cfg)
    if step_cfg.build_tree ~= nil then
        return step_cfg.build_tree
    end

    if profile.build_tree ~= nil then
        return profile.build_tree
    end

    if profile.build_tree_from_build_type then
        local build_type = beez.env_or("BUILD_TYPE", "Release")
        return "build/build/" .. build_type
    end

    return defaults.build_tree
end

function M.resolve(step_cfg, profile_name, root)
    local cfg = step_cfg or {}
    local profile = defaults.build_profiles[profile_name]
    if profile == nil then
        error("unknown gcc-objc profile: " .. tostring(profile_name))
    end

    local build_tree = M.resolve_build_tree(profile, cfg)

    return {
        run_args = cfg.run_args or profile.run_args or "",
        interpreter_binary = cfg.interpreter_binary or cfg.python_binary or defaults.python_binary,

        profile_name = profile_name,
        scope = profile.scope,
        build_tree = build_tree,
        build_tree_abs = root .. "/" .. build_tree,
        bin_dir = build_tree .. "/bin",
        bin_dir_abs = root .. "/" .. build_tree .. "/bin",
        reports_dir = cfg.reports_dir or defaults.reports_dir,
        index_lua = build_tree .. "/" .. defaults.index_file,
        index_lua_abs = root .. "/" .. build_tree .. "/" .. defaults.index_file,
        index_script = cfg.index_script or defaults.index_script,
        python_binary = cfg.python_binary or defaults.python_binary,
        cc = cfg.cc or beez.env_or("CC", defaults.default_cc),
        cxx = cfg.cxx or beez.env_or("CXX", defaults.default_cxx),
        log_prefix_setup = cfg.log_prefix_setup or defaults.log_prefix_setup,
        log_prefix_compile = cfg.log_prefix_compile or cfg.log_prefix or defaults.log_prefix_compile,
        log_prefix_link = cfg.log_prefix_link or defaults.log_prefix_link,
        log_prefix_test = cfg.log_prefix_test or defaults.log_prefix_test,
        setup_rev = cfg.setup_rev or defaults.setup_rev,
        compile_rev = cfg.compile_rev or defaults.compile_rev,
        link_rev = cfg.link_rev or defaults.link_rev,
        test_rev = cfg.test_rev or defaults.test_rev,
        parallelism = cfg.parallelism or 16,
        cache_key = cfg.cache_key or profile_name,
        setup_description = profile.setup_description,
        compile_description = profile.compile_description,
        link_description = profile.link_description,
        test_description = profile.test_description,
    }
end

return M
