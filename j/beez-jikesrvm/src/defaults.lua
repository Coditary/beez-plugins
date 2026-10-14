local M = {}

M.runnable = true

M.build_dir = "build/jikesrvm"
M.classes_dir = M.build_dir .. "/classes"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.jikesrvm_binary = "jikesrvm"
M.javac_binary = "javac"
M.java_binary = "java"
M.maven_binary = "mvn"
M.gradle_binary = "gradle"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[jikesrvm-setup]"
M.log_prefix_compile = "[jikesrvm-compile]"
M.log_prefix_bundle = "[jikesrvm-bundle]"
M.log_prefix_test = "[jikesrvm-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "**/*.java",
}

M.build_profiles = {
    code = {
        scope = "jikesrvm",
        build_mode = "release",
        javac_flags = "-O",
        setup_description = "Fetch Java dependencies (Maven/Gradle) for JikesRVM",
        compile_description = "Compile with javac for JikesRVM (release, -O)",
        bundle_description = "Verify JikesRVM release artifacts",
        test_description = "Run Java unit tests on JikesRVM (release)",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        javac_flags = "-g",
        setup_description = "Fetch Java dependencies (Maven/Gradle debug) for JikesRVM",
        compile_description = "Compile with javac for JikesRVM (debug, -g)",
        bundle_description = "Verify JikesRVM debug artifacts",
        test_description = "Run Java unit tests on JikesRVM (debug, verbose)",
        test_args = "-X",
        run_description = "Run application (debug)",
    },
}

M.configure_step_profiles = {
    ["configure:setup"] = "code",
}

M.compile_step_profiles = {
    ["compile:code"] = "code",
    ["compile:debug"] = "debug",
}

M.bundle_step_profiles = {
    ["bundle:code"] = "code",
    ["bundle:debug"] = "debug",
}

M.test_step_profiles = {
    ["test:unit"] = "code",
    ["test:debug"] = "debug",
}

M.run_step_profiles = {
    ["run:code"] = "code",
    ["run:debug"] = "debug",
}

return M
