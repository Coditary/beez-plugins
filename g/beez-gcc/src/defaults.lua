local M = {}

M.runnable = true

M.plugin_id = "gcc"
M.scope = "gcc"
M.debug_build_tree = "build/build/Debug"
M.coverage_build_tree = "build/build/Coverage"
M.sanitize_build_tree = "build/build/Sanitize"
M.tsan_build_tree = "build/build/Tsan"

M.index_file = ".beez-gcc-index.lua"
M.scripts_glob = ".beez-gcc-scripts/**"

M.index_script = "scripts/compdb_index.py"
M.python_binary = "python3"

M.log_prefix_compile = "[gcc-compile]"
M.log_prefix_link = "[gcc-link]"

M.compile_rev = "1"
M.link_rev = "1"

local function compile_outputs(build_tree)
    return {
        build_tree .. "/compile_commands.json",
        build_tree .. "/" .. M.index_file,
        build_tree .. "/" .. M.scripts_glob,
    }
end

local function link_outputs(build_tree)
    return {
        build_tree .. "/bin/**",
    }
end

local cpp_compile_inputs = {
    "conanfile.py",
    "CMakeLists.txt",
    "cmake/**",
    "conan/**",
    "src/**/*.cpp",
    "include/**/*.hpp",
    "tests/**/*.cpp",
}

local debug_compile_inputs = {
    "conanfile.py",
    "CMakeLists.txt",
    "cmake/**",
    "src/**/*.cpp",
    "include/**/*.hpp",
}

M.build_profiles = {
    code = {
        scope = M.scope,
        build_tree_from_build_type = true,
        compile_inputs = cpp_compile_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        compile_description = "GCC compile from compile_commands.json",
        link_description = "GCC link binaries under bin/",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_type = "Debug",
        build_tree = M.debug_build_tree,
        compile_inputs = debug_compile_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        compile_description = "GCC compile (Debug)",
        link_description = "GCC link (Debug)",
        run_description = "Run application (debug)",
    },

    coverage = {
        scope = "coverage",
        build_type = "Debug",
        build_tree = M.coverage_build_tree,
        compile_inputs = cpp_compile_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        compile_description = "GCC compile with coverage instrumentation",
        link_description = "GCC link coverage binaries",
        run_description = "Run application (coverage)",
    },

    sanitize = {
        scope = "sanitize",
        build_type = "Debug",
        build_tree = M.sanitize_build_tree,
        compile_inputs = cpp_compile_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        compile_description = "GCC compile with ASan/UBSan",
        link_description = "GCC link sanitizer binaries",
        run_description = "Run application (sanitize)",
    },

    tsan = {
        scope = "tsan",
        build_type = "Debug",
        build_tree = M.tsan_build_tree,
        compile_inputs = cpp_compile_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        compile_description = "GCC compile with ThreadSanitizer",
        link_description = "GCC link TSan binaries",
        run_description = "Run application (tsan)",
    },
}

M.compile_step_profiles = {
    ["gcc:compile"] = "code",
    ["gcc:compile:debug"] = "debug",
    ["gcc:compile:coverage"] = "coverage",
    ["gcc:compile:sanitize"] = "sanitize",
    ["gcc:compile:tsan"] = "tsan",
}

M.link_step_profiles = {
    ["gcc:link"] = "code",
    ["gcc:link:debug"] = "debug",
    ["gcc:link:coverage"] = "coverage",
    ["gcc:link:sanitize"] = "sanitize",
    ["gcc:link:tsan"] = "tsan",
}

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.run_step_profiles = {
    ["gcc:run"] = "code",
    ["gcc:run:coverage"] = "coverage",
    ["gcc:run:debug"] = "debug",
    ["gcc:run:sanitize"] = "sanitize",
    ["gcc:run:tsan"] = "tsan",
}

return M
