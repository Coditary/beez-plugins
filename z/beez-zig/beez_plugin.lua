local defaults = require("src.defaults")
local runner = require("src.runner")

local function resolve_outputs()
    return {
        defaults.bin_dir .. "/**",
        defaults.cache_dir .. "/**",
    }
end

local function setup_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    return {
        phase = "setup",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { defaults.build_dir .. "/.zig-configured" },
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
        output = resolve_outputs(),
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
        input = resolve_outputs(),
        output = resolve_outputs(),
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
        output = { defaults.reports_dir .. "/test/zig-" .. profile_name .. ".ok" },
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
for name, profile in pairs(defaults.configure_step_profiles) do steps[name] = setup_def(name, profile) end
for name, profile in pairs(defaults.compile_step_profiles) do steps[name] = compile_def(name, profile) end
for name, profile in pairs(defaults.bundle_step_profiles) do steps[name] = bundle_def(name, profile) end
for name, profile in pairs(defaults.test_step_profiles) do steps[name] = test_def(name, profile) end
for name, profile in pairs(defaults.run_step_profiles) do steps[name] = run_def(name, profile) end

plugin("zig", {
    version = "1.0.0",
    description = "Official Zig compiler (LLVM backend) with auto-detected build targets",
    organization = "coditary",

    config = {
        defaults = {
            zig_binary = defaults.zig_binary,
            build_dir = defaults.build_dir,
            bin_dir = defaults.bin_dir,
            cache_dir = defaults.cache_dir,
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
        { "setup",   { "setup[zig]" } },
        { "compile", { "compile[zig]" } },
        { "bundle",  { "bundle[zig]" } },
        { "test",    { "test[zig]" } },
    },
}
