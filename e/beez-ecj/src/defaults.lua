local M = {}

M.runnable = true

M.build_dir = "build/ecj"
M.classes_dir = M.build_dir .. "/classes"
M.bin_dir = M.build_dir .. "/bin"
M.reports_dir = "report"

M.ecj_binary = "ecj"
M.java_binary = "java"
M.maven_binary = "mvn"
M.gradle_binary = "./gradlew"
M.setup_rev = "1"
M.compile_rev = "1"
M.bundle_rev = "1"
M.test_rev = "1"

M.log_prefix_setup = "[ecj-setup]"
M.log_prefix_compile = "[ecj-compile]"
M.log_prefix_bundle = "[ecj-bundle]"
M.log_prefix_test = "[ecj-test]"

M.log_prefix_run = "[run]"
M.run_rev = "1"

M.common_inputs = {
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "settings.gradle",
    "settings.gradle.kts",
    "**/*.java",
}

M.build_profiles = {
    code = {
        scope = "ecj",
        build_mode = "release",
        output_name = "app",
        ecj_args = { "-O", "-g:none" },
        source_level = "17",
        target_level = "17",
        setup_description = "Resolve Java project dependencies for ECJ",
        compile_description = "Compile Java sources with ECJ (release)",
        bundle_description = "Verify ECJ release class artifacts",
        test_description = "Run Java unit tests",
        test_args = "",
    },

    debug = {
        scope = "debug",
        build_mode = "debug",
        output_name = "app",
        ecj_args = { "-g", "-preserveAllLocals" },
        source_level = "17",
        target_level = "17",
        setup_description = "Resolve Java project dependencies for ECJ (debug)",
        compile_description = "Compile Java sources with ECJ (debug)",
        bundle_description = "Verify ECJ debug class artifacts",
        test_description = "Run Java unit tests (verbose)",
        test_args = "--info",
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
