local M = {}

M.runnable = true

M.plugin_id = "gnustep-objc"
M.scope = "gnustep"
M.build_tree = "build/gnustep-objc"
M.debug_build_tree = "build/gnustep-objc-debug"
M.reports_dir = "report"

M.index_file = ".beez-gnustep-objc-index.lua"
M.scripts_glob = ".beez-gnustep-objc-scripts/**"

M.index_script = "scripts/compdb_index.py"
M.python_binary = "python3"
M.gnustep_config = "gnustep-config"

M.default_cc = "gcc -x objective-c"
M.default_cxx = "g++"

M.log_prefix_setup = "[gnustep-objc-setup]"
M.log_prefix_compile = "[gnustep-objc-compile]"
M.log_prefix_link = "[gnustep-objc-link]"
M.log_prefix_test = "[gnustep-objc-test]"

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
    "GNUmakefile",
    "**/GNUmakefile",
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
        reports_dir .. "/gnustep-objc/test.ok",
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
        setup_description = "Index compile_commands.json for GNUstep Objective-C",
        compile_description = "GNUstep Objective-C compile from compile_commands.json",
        link_description = "GNUstep Objective-C link binaries under bin/",
        test_description = "Run CTest suite for GNUstep Objective-C build",
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
        setup_description = "Index compile_commands.json for GNUstep Objective-C (debug)",
        compile_description = "GNUstep Objective-C compile from compile_commands.json (debug)",
        link_description = "GNUstep Objective-C link debug binaries under bin/",
        test_description = "Run CTest suite for GNUstep Objective-C debug build",
        ctest_args = "--output-on-failure",
        run_description = "Run application (debug)",
    },
}

M.setup_step_profiles = {
    ["gnustep-objc:setup"] = "code",
    ["gnustep-objc:setup:debug"] = "debug",
}

M.compile_step_profiles = {
    ["gnustep-objc:compile"] = "code",
    ["gnustep-objc:compile:debug"] = "debug",
}

M.link_step_profiles = {
    ["gnustep-objc:link"] = "code",
    ["gnustep-objc:link:debug"] = "debug",
}

M.test_step_profiles = {
    ["gnustep-objc:test"] = "code",
    ["gnustep-objc:test:debug"] = "debug",
}

M.run_step_profiles = {
    ["gnustep-objc:run"] = "code",
    ["gnustep-objc:run:debug"] = "debug",
}

return M
