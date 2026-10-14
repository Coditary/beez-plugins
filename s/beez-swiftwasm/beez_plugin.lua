local defaults = require("src.defaults")
local runner = require("src.runner")

local function resolve_outputs(profile_name)
    local profile = defaults.build_profiles[profile_name]
    return { profile.bin_dir .. "/**" }
end

local function setup_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]

    return {
        phase = "setup",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { profile.build_path .. "/.swiftwasm-resolved" },
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

    return {
        phase = "test",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { defaults.reports_dir .. "/test/swiftwasm-" .. profile_name .. ".ok" },
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


plugin("swiftwasm", {
    version = "1.0.0",
    description = "SwiftWasm — compile Swift to WebAssembly with the SwiftWasm SDK",
    organization = "coditary",

    config = {
        defaults = {
            swift_binary = defaults.swift_binary,
            wasm_ld_binary = defaults.wasm_ld_binary,
            build_dir = defaults.build_dir,
            setup_rev = defaults.setup_rev,
            compile_rev = defaults.compile_rev,
            bundle_rev = defaults.bundle_rev,
            test_rev = defaults.test_rev,
        },
    },

    steps = plugin_steps,
})

workflows {
    wasm = {
        { "setup", { "setup[wasm]" } },
        { "compile", { "compile[wasm]" } },
        { "bundle", { "bundle[wasm]" } },
        { "test", { "test[wasm]" } },
    },
}
