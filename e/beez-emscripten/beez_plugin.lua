local defaults = require("src.defaults")
local runner = require("src.runner")

local function resolve_profile_build_tree(profile_name)
    local profile = defaults.build_profiles[profile_name]
    return profile.build_tree or defaults.build_tree
end

local function resolve_outputs(profile, build_tree)
    local outputs = profile.compile_outputs
    if type(outputs) == "function" then
        return outputs(build_tree)
    end

    return outputs
end

local function resolve_bundle_outputs(profile, build_tree)
    local outputs = profile.bundle_outputs
    if type(outputs) == "function" then
        return outputs(build_tree)
    end

    return outputs
end

local function setup_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    local build_tree = resolve_profile_build_tree(profile_name)

    return {
        phase = "setup",
        scope = profile.scope,
        input = defaults.common_inputs,
        output = { build_tree .. "/.emscripten-prepared" },
        description = profile.setup_description,
        config = {
            profile = profile_name,
            setup_rev = defaults.setup_rev,
        },
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
    local build_tree = resolve_profile_build_tree(profile_name)

    return {
        phase = "compile",
        scope = profile.scope,
        input = profile.compile_inputs,
        output = resolve_outputs(profile, build_tree),
        description = profile.compile_description,
        config = {
            profile = profile_name,
            cache_key = profile_name .. ":compile",
            compile_rev = defaults.compile_rev,
        },
        run = function(ctx)
            return runner.compile(ctx, step_name)
        end,
    }
end

local function bundle_step_def(step_name, profile_name)
    local profile = defaults.build_profiles[profile_name]
    local build_tree = resolve_profile_build_tree(profile_name)

    return {
        phase = "bundle",
        scope = profile.scope,
        input = {
            build_tree .. "/" .. defaults.index_file,
            build_tree .. "/" .. defaults.scripts_glob,
        },
        output = resolve_bundle_outputs(profile, build_tree),
        description = profile.bundle_description,
        config = {
            profile = profile_name,
            cache_key = profile_name .. ":bundle",
            bundle_rev = defaults.bundle_rev,
        },
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
        output = { defaults.reports_dir .. "/test/emscripten-wasm.ok" },
        description = profile.test_description,
        config = {
            profile = profile_name,
            test_rev = defaults.test_rev,
        },
        run = function(ctx)
            return runner.test(ctx, step_name)
        end,
    }
end

local plugin_steps = {}

for step_name, profile_name in pairs(defaults.setup_step_profiles) do
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


plugin("emscripten", {
    version = "1.0.0",
    description = "Emscripten — C/C++ to WebAssembly via LLVM (emcc/em++)",
    organization = "coditary",

    config = {
        defaults = {
            index_script = defaults.index_script,
            python_binary = defaults.python_binary,
            cc = defaults.cc,
            cxx = defaults.cxx,
            compile_opt = defaults.compile_opt,
            setup_rev = defaults.setup_rev,
            compile_rev = defaults.compile_rev,
            bundle_rev = defaults.bundle_rev,
            test_rev = defaults.test_rev,
            log_prefix_setup = defaults.log_prefix_setup,
            log_prefix_compile = defaults.log_prefix_compile,
            log_prefix_bundle = defaults.log_prefix_bundle,
            log_prefix_test = defaults.log_prefix_test,
            parallelism = 16,
        },
    },

    steps = plugin_steps,
})

workflows {
    wasm = {
        { "setup",   { "setup[wasm]" } },
        { "compile", { "compile[wasm]" } },
        { "bundle",  { "bundle[wasm]" } },
        { "test",    { "test[wasm]" } },
    },
}
