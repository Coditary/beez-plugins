local M = {}

M.runnable = true

M.plugin_id = "emscripten"
M.scope = "wasm"
M.build_tree = "build/emscripten/wasm"
M.debug_build_tree = "build/emscripten/debug"
M.reports_dir = "report"

M.index_file = ".beez-emscripten-index.lua"
M.scripts_glob = ".beez-emscripten-scripts/**"

M.index_script = "scripts/compdb_index.py"
M.python_binary = "python3"

M.cc = "emcc"
M.cxx = "em++"
M.compile_opt = "-O3"

M.log_prefix_setup = "[emscripten-setup]"
M.log_prefix_compile = "[emscripten-compile]"
M.log_prefix_bundle = "[emscripten-bundle]"
M.log_prefix_test = "[emscripten-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

local function compile_outputs(build_tree)
    return {
        build_tree .. "/compile_commands.json",
        build_tree .. "/" .. M.index_file,
        build_tree .. "/" .. M.scripts_glob,
    }
end

local function bundle_outputs(build_tree)
    return {
        build_tree .. "/**/*.wasm",
        build_tree .. "/**/*.js",
        build_tree .. "/**/*.html",
    }
end

M.common_inputs = {
    "CMakeLists.txt",
    "compile_commands.json",
    "conanfile.py",
    "cmake/**",
    "conan/**",
    "src/**/*.c",
    "src/**/*.cpp",
    "include/**/*.h",
    "include/**/*.hpp",
    "tests/**/*.c",
    "tests/**/*.cpp",
}

M.build_profiles = {
    wasm = {
        scope = M.scope,
        build_tree = M.build_tree,
        compile_inputs = M.common_inputs,
        compile_outputs = compile_outputs,
        bundle_outputs = bundle_outputs,
        setup_description = "Prepare Emscripten Wasm build tree",
        compile_description = "Emscripten compile from compile_commands.json (emcc -O3)",
        bundle_description = "Emscripten link Wasm/JS artifacts",
        test_description = "Run Emscripten Wasm tests via ctest",
        ctest_args = "--output-on-failure",
        run_description = "Run application (wasm)",
    },

    debug = {
        scope = "debug",
        build_tree = M.debug_build_tree,
        compile_opt = "-g -O0",
        compile_inputs = M.common_inputs,
        compile_outputs = compile_outputs,
        bundle_outputs = bundle_outputs,
        setup_description = "Prepare Emscripten debug build tree",
        compile_description = "Emscripten compile from compile_commands.json (debug, -g -O0)",
        bundle_description = "Emscripten link debug Wasm/JS artifacts",
        test_description = "Run Emscripten debug Wasm tests via ctest",
        ctest_args = "--output-on-failure",
        run_description = "Run application (debug)",
    },
}

M.setup_step_profiles = {
    ["emscripten:setup"] = "wasm",
    ["emscripten:setup:debug"] = "debug",
}

M.compile_step_profiles = {
    ["emscripten:compile"] = "wasm",
    ["emscripten:compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["emscripten:bundle"] = "wasm",
    ["emscripten:bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["emscripten:test"] = "wasm",
    ["emscripten:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["emscripten:run"] = "wasm",
    ["emscripten:run:debug"] = "debug",
}

return M
