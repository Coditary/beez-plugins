local M = {}

M.runnable = true

M.build_dir = "build/harmony"
M.classes_dir = M.build_dir .. "/classes"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.javac_binary = "javac"
M.java_binary = "java"
M.maven_binary = "mvn"
M.gradle_binary = "gradle"

M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[harmony-setup]"
M.log_prefix_compile = "[harmony-compile]"
M.log_prefix_bundle = "[harmony-bundle]"
M.log_prefix_test = "[harmony-test]"

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
        scope = "harmony",
        build_mode = "release",
        javac_flags = "-O",
        setup_description = "Fetch Java dependencies for Harmony/DRLVM (Maven/Gradle)",
        compile_description = "Compile with Harmony javac (release, -O)",
        bundle_description = "Verify Harmony/DRLVM release artifacts",
        test_description = "Run Java unit tests with Harmony/DRLVM (release)",
        test_args = "",
        run_description = "Run application (code)",
    },

    debug = {
        scope = "harmony",
        build_mode = "debug",
        javac_flags = "-g",
        setup_description = "Fetch Java dependencies for Harmony/DRLVM (debug)",
        compile_description = "Compile with Harmony javac (debug, -g)",
        bundle_description = "Verify Harmony/DRLVM debug artifacts",
        test_description = "Run Java unit tests with Harmony/DRLVM (debug, verbose)",
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
