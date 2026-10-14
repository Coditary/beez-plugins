local defaults = require("src.defaults")
local runner = require("src.runner")

local function setup_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "setup",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { defaults.build_dir .. "/.metapost-setup" },
        description = profile.setup_description,
        config = { profile = profile_name },
        run = function(ctx)
            return runner.setup(ctx, step_name)
        end,
    }
end



local function compile_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "compile",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { defaults.bin_dir .. "/**" },
        description = profile.compile_description,
        config = { profile = profile_name, cache_key = profile_name .. ":compile" },
        run = function(ctx)
            return runner.compile(ctx, step_name)
        end,
    }
end

local function bundle_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "bundle",
        scope = profile.scope,
        input = { defaults.bin_dir .. "/**" },
        output = { defaults.bin_dir .. "/**" },
        description = profile.bundle_description,
        config = { profile = profile_name, cache_key = profile_name .. ":bundle" },
        run = function(ctx)
            return runner.bundle(ctx, step_name)
        end,
    }
end

local function test_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    local test_scope = profile.scope == "app" and "test" or profile.scope
    return {
        phase = "test",
        scope = test_scope,
        input = defaults.common_inputs,
        output = { defaults.reports_dir .. "/test/metapost-" .. profile_name .. ".ok" },
        description = profile.test_description,
        config = { profile = profile_name },
        run = function(ctx)
            return runner.test(ctx, step_name)
        end,
    }
end

local plugin_steps = {}

for step_name, profile_name in pairs(defaults.configure_step_profiles) do
    plugin_steps[step_name] = setup_step_def(step_name, profile_name)
end

for step_name, profile_name in pairs(defaults.compile_step_profiles) do
    plugin_steps[step_name] = compile_step_def(step_name, profile_name)
end

for step_name, profile_name in pairs(defaults.bundle_step_profiles) do
    plugin_steps[step_name] = bundle_step_def(step_name, profile_name)
end

for step_name, profile_name in pairs(defaults.test_step_profiles) do
    plugin_steps[step_name] = test_step_def(step_name, profile_name)
end


plugin("metapost", {
    version = "1.0.0",
    description = "MetaPost mpost — diagram rendering from *.mp sources",
    organization = "coditary",

    config = {
        defaults = {
            mpost_binary = defaults.mpost_binary,
            build_dir = defaults.build_dir,
            bin_dir = defaults.bin_dir,
            setup_rev = defaults.setup_rev,
            compile_rev = defaults.compile_rev,
            bundle_rev = defaults.bundle_rev,
            test_rev = defaults.test_rev,
        },
    },

    steps = plugin_steps,
})
