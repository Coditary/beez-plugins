local defaults = require("src.defaults")
local runner = require("src.runner")

local function resolve_outputs(profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        profile.scope == "debug" and defaults.bytecode_dir .. "/**" or defaults.bin_dir .. "/**",
        defaults.bytecode_dir .. "/**",
    }
end

local function setup_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]

    return {
        phase = "setup",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { defaults.build_dir .. "/.ocaml-setup" },
        description = profile.setup_description,
        config = { profile = profile_name },
        run = function(ctx)
            return runner.setup(ctx, step_name)
        end,
    }
end


local function run_scope_for(profile_name)
    local profile = defaults.build_profiles[profile_name]
    if profile ~= nil and (profile.scope == "debug" or profile.build_mode == "debug") then
        return "debug"
    end
    if profile_name == "debug" or profile_name:find("debug") ~= nil then
        return "debug"
    end
    if profile ~= nil and profile.scope ~= nil and profile.scope ~= "app" and profile.scope ~= "test" and profile.scope ~= "debug" then
        if profile_name == "code" or profile_name == "app" then
            return "app"
        end
        return profile.scope
    end
    return "app"
end

local function run_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "run",
        scope = run_scope_for(profile_name),
        description = profile.run_description or ("Run application (" .. profile_name .. ")"),
        config = { profile = profile_name },
        run = function(ctx)
            return runner.run(ctx, step_name)
        end,
    }
end

local function compile_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]

    return {
        phase = "compile",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = resolve_outputs(profile_name),
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
        input = resolve_outputs(profile_name),
        output = resolve_outputs(profile_name),
        description = profile.bundle_description,
        config = { profile = profile_name, cache_key = profile_name .. ":bundle" },
        run = function(ctx)
            return runner.bundle(ctx, step_name)
        end,
    }
end

local function test_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    local test_scope = (profile.scope == "bytecode") and "test" or profile.scope

    return {
        phase = "test",
        scope = test_scope,
        input = defaults.common_inputs,
        output = { defaults.reports_dir .. "/test/ocaml-" .. profile_name .. ".ok" },
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
for step_name, profile_name in pairs(defaults.run_step_profiles) do
    plugin_steps[step_name] = run_step_def(step_name, profile_name)
end


plugin("ocamlc", {
    version = "1.0.0",
    description = "OCaml bytecode compiler (ocamlc/dune) — dune or standalone with auto-detected sources",
    organization = "coditary",

    config = {
        defaults = {
            ocamlc_binary = defaults.ocamlc_binary,
            dune_binary = defaults.dune_binary,
            build_dir = defaults.build_dir,
            bytecode_dir = defaults.bytecode_dir,
            bin_dir = defaults.bin_dir,
            setup_rev = defaults.setup_rev,
            compile_rev = defaults.compile_rev,
            bundle_rev = defaults.bundle_rev,
            test_rev = defaults.test_rev,
        },
    },

    steps = plugin_steps,
})
