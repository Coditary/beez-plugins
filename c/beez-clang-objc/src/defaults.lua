local M = {}

M.runnable = true

M.plugin_id = "clang-objc"
M.scope = "objc"
M.build_tree = "build/clang-objc"
M.debug_build_tree = "build/clang-objc-debug"
M.reports_dir = "report"

M.index_file = ".beez-clang-objc-index.lua"
M.scripts_glob = ".beez-clang-objc-scripts/**"

M.index_script = "scripts/compdb_index.py"
M.python_binary = "python3"

M.default_cc = "clang -x objective-c"
M.default_cxx = "clang++"

M.log_prefix_setup = "[clang-objc-setup]"
M.log_prefix_compile = "[clang-objc-compile]"
M.log_prefix_link = "[clang-objc-link]"
M.log_prefix_test = "[clang-objc-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.setup_rev = "1"
M.compile_rev = "1"
M.link_rev = "1"
M.test_rev = "1"

M.common_inputs = {
    "compile_commands.json",
    "**/*.m",
    "**/*.mm",
    "**/*.h",
    "CMakeLists.txt",
    "cmake/**",
}

local function setup_outputs(build_tree)
    return {
        build_tree .. "/" .. M.index_file,
        build_tree .. "/" .. M.scripts_glob,
    }
end

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

local function test_outputs(reports_dir)
    return {
        reports_dir .. "/clang-objc/test.ok",
    }
end

M.build_profiles = {
    code = {
        scope = M.scope,
        build_tree = M.build_tree,
        setup_inputs = M.common_inputs,
        setup_outputs = setup_outputs,
        compile_inputs = M.common_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        test_outputs = test_outputs,
        setup_description = "Index compile_commands.json for Objective-C (Xcode toolchain)",
        compile_description = "Clang compile Objective-C sources from compile_commands.json",
        link_description = "Clang link Objective-C binaries under bin/",
        test_description = "Run CTest suite for Objective-C build",
        ctest_args = "--output-on-failure",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_tree = M.debug_build_tree,
        setup_inputs = M.common_inputs,
        setup_outputs = setup_outputs,
        compile_inputs = M.common_inputs,
        compile_outputs = compile_outputs,
        link_outputs = link_outputs,
        test_outputs = test_outputs,
        setup_description = "Index compile_commands.json for Objective-C (debug)",
        compile_description = "Clang compile Objective-C sources (debug, -g)",
        link_description = "Clang link Objective-C debug binaries under bin/",
        test_description = "Run CTest suite for Objective-C debug build",
        ctest_args = "--output-on-failure",
        run_description = "Run application (debug)",
    },
}

M.setup_step_profiles = {
    ["clang-objc:setup"] = "code",
    ["clang-objc:setup:debug"] = "debug",
}

M.compile_step_profiles = {
    ["clang-objc:compile"] = "code",
    ["clang-objc:compile:debug"] = "debug",
}

M.link_step_profiles = {
    ["clang-objc:link"] = "code",
    ["clang-objc:link:debug"] = "debug",
}

M.test_step_profiles = {
    ["clang-objc:test"] = "code",
    ["clang-objc:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["clang-objc:run"] = "code",
    ["clang-objc:run:debug"] = "debug",
}

return M
