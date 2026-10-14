local M = {}

M.runnable = true

M.plugin_id = "gcc-objc"
M.scope = "gcc-objc"
M.build_tree = "build/gcc-objc"
M.debug_build_tree = "build/gcc-objc-debug"
M.bin_dir = M.build_tree .. "/bin"
M.reports_dir = "report"

M.index_file = ".beez-gcc-objc-index.lua"
M.scripts_glob = ".beez-gcc-objc-scripts/**"

M.index_script = "scripts/compdb_index.py"
M.python_binary = "python3"

M.default_cc = "gcc -x objective-c"
M.default_cxx = "g++"

M.log_prefix_setup = "[gcc-objc-setup]"
M.log_prefix_compile = "[gcc-objc-compile]"
M.log_prefix_link = "[gcc-objc-link]"
M.log_prefix_test = "[gcc-objc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.setup_rev = "1"
M.compile_rev = "1"
M.link_rev = "1"
M.test_rev = "1"

M.common_inputs = {
    "compile_commands.json",
    "conanfile.py",
    "CMakeLists.txt",
    "cmake/**",
    "conan/**",
    "**/*.m",
    "**/*.mm",
    "**/*.h",
    "tests/**/*.m",
}

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

M.build_profiles = {
    code = {
        scope = M.scope,
        build_tree = M.build_tree,
        compile_inputs = M.common_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        setup_description = "Verify GCC Objective-C toolchain and index compile_commands.json",
        compile_description = "GCC Objective-C compile from compile_commands.json",
        link_description = "GCC Objective-C link binaries under bin/",
        test_description = "Run CTest suite for GCC Objective-C build tree",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_tree = M.debug_build_tree,
        compile_inputs = M.common_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        setup_description = "Verify GCC Objective-C toolchain (debug)",
        compile_description = "GCC Objective-C compile from compile_commands.json (debug)",
        link_description = "GCC Objective-C link debug binaries under bin/",
        test_description = "Run CTest suite for GCC Objective-C debug build tree",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
    ["configure:debug"] = "debug",
}

M.compile_step_profiles = {
    ["gcc-objc:compile"] = "code",
    ["gcc-objc:compile:debug"] = "debug",
}

M.link_step_profiles = {
    ["gcc-objc:link"] = "code",
    ["gcc-objc:link:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["gcc-objc:run"] = "code",
    ["gcc-objc:run:debug"] = "debug",
}

return M
