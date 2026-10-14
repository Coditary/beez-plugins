local defaults = require("src.defaults")
local runner = require("src.runner")

local function resolve_outputs(profile_name)
    local profile = defaults.build_profiles[profile_name]
    return { profile.bin_dir .. "/**" }
end

local function setup_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "setup",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { profile.target_dir .. "/.rustc-gcc-fetched" },
        description = profile.setup_description,
        config = { profile = profile_name },
        run = function(ctx) return runner.setup(ctx, step_name) end,
    }
end

local function compile_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "compile",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = resolve_outputs(profile_name),
        description = profile.compile_description,
        config = { profile = profile_name, cache_key = profile_name .. ":compile" },
        run = function(ctx) return runner.compile(ctx, step_name) end,
    }
end

local function bundle_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "bundle",
        scope = profile.scope,
        input = resolve_outputs(profile_name),
        output = resolve_outputs(profile_name),
        description = profile.bundle_description,
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
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "test",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { defaults.reports_dir .. "/test/rustc-gcc-" .. profile_name .. ".ok" },
        description = profile.test_description,
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

plugin("rustc-gcc", {
    version = "1.0.0",
    description = "Rust compiler with GCC backend (rustc_codegen_gcc)",
    organization = "coditary",
    config = {
        defaults = {
            cargo_binary = defaults.cargo_binary,
            rustc_binary = defaults.rustc_binary,
            target_dir = defaults.target_dir,
            rustflags = defaults.rustflags,
            codegen_backend = defaults.codegen_backend,
            setup_rev = defaults.setup_rev,
            compile_rev = defaults.compile_rev,
            bundle_rev = defaults.bundle_rev,
            test_rev = defaults.test_rev,
        },
    },
    steps = steps,
})

workflows {
    build = {
        { "setup",   { "setup[rustc-gcc]" } },
        { "compile", { "compile[rustc-gcc]" } },
        { "bundle",  { "bundle[rustc-gcc]" } },
        { "test",    { "test[rustc-gcc]" } },
    },
}
