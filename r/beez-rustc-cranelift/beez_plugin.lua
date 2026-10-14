local defaults = require("src.defaults")
local runner = require("src.runner")

local function setup_def(step_name, profile_name)
    local p = defaults.build_profiles[profile_name]
    return {
        phase = "setup",
        scope = p.scope,
        input = defaults.common_inputs,
        output = { p.target_dir .. "/.cargo-fetched" },
        description = p.setup_description,
        config = { profile = profile_name },
        run = function(ctx) return runner.setup(ctx, step_name) end,
    }
end

local function compile_def(step_name, profile_name)
    local p = defaults.build_profiles[profile_name]
    return {
        phase = "compile",
        scope = p.scope,
        input = defaults.common_inputs,
        output = { p.bin_dir .. "/**" },
        description = p.compile_description,
        config = { profile = profile_name, cache_key = profile_name .. ":compile" },
        run = function(ctx) return runner.compile(ctx, step_name) end,
    }
end

local function bundle_def(step_name, profile_name)
    local p = defaults.build_profiles[profile_name]
    return {
        phase = "bundle",
        scope = p.scope,
        input = { p.bin_dir .. "/**" },
        output = { p.bin_dir .. "/**" },
        description = p.bundle_description,
        config = { profile = profile_name, cache_key = profile_name .. ":bundle" },
        run = function(ctx) return runner.bundle(ctx, step_name) end,
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

local function test_def(step_name, profile_name)
    local p = defaults.build_profiles[profile_name]
    return {
        phase = "test",
        scope = p.scope,
        input = defaults.common_inputs,
        output = { defaults.reports_dir .. "/test/rustc-cranelift-" .. profile_name .. ".ok" },
        description = p.test_description,
        config = { profile = profile_name },
        run = function(ctx) return runner.test(ctx, step_name) end,
    }
end


local function run_def(step_name, profile_name)
    local p = defaults.build_profiles[profile_name]
    return {
        phase = "run",
        scope = run_scope_for(profile_name),
        description = p.run_description or ("Run application (" .. profile_name .. ")"),
        config = { profile = profile_name },
        run = function(ctx) return runner.run(ctx, step_name) end,
    }
end

local steps = {}
for n, p in pairs(defaults.configure_step_profiles) do steps[n] = setup_def(n, p) end
for n, p in pairs(defaults.compile_step_profiles) do steps[n] = compile_def(n, p) end
for n, p in pairs(defaults.bundle_step_profiles) do steps[n] = bundle_def(n, p) end
for n, p in pairs(defaults.test_step_profiles) do steps[n] = test_def(n, p) end
for n, p in pairs(defaults.run_step_profiles) do steps[n] = run_def(n, p) end

plugin("rustc-cranelift", {
    version = "1.0.0",
    description = "Rust compiler with Cranelift backend for fast debug builds",
    organization = "coditary",
    config = {
        defaults = {
            cargo_binary = defaults.cargo_binary,
            target_dir = defaults.target_dir,
            codegen_backend = defaults.codegen_backend,
        },
    },
    steps = steps,
})

workflows {
    build = {
        { "setup",   { "setup[cranelift]" } },
        { "compile", { "compile[cranelift]" } },
        { "bundle",  { "bundle[cranelift]" } },
        { "test",    { "test[cranelift]" } },
    },
}
