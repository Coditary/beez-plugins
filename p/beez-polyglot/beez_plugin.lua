-- Polyglot orchestration: auto-detect languages and provide unified workflows.
-- Load alongside language-specific plugins (go, cargo, conan/clang).
-- All plugins share standard phases/scopes — Beez runs matching steps in parallel.

local defaults = require("src.defaults")
local runner = require("src.runner")

plugin("polyglot", {
    version = "1.0.0",
    description = "Auto-detect project languages and orchestrate polyglot builds",
    organization = "coditary",

    config = {
        defaults = {
            detect_rev = defaults.detect_rev,
        },
    },

    steps = {
        ["polyglot:detect"] = {
            phase = "generate",
            scope = "repo",
            input = {
                "go.mod",
                "Cargo.toml",
                "CMakeLists.txt",
                "conanfile.py",
                "conanfile.txt",
                "**/*.go",
                "**/*.rs",
                "src/**/*.cpp",
            },
            output = { defaults.reports_dir .. "/polyglot/detect.txt" },
            description = "Detect project languages and recommend plugins",
            config = {},
            run = function(ctx)
                return runner.detect(ctx)
            end,
        },
    },
})

-- Polyglot workflows: invoke standard phases/scopes.
-- Beez runs ALL matching steps from ALL loaded plugins in parallel per stage.

workflows {
    -- Detect languages first, then build everything found
    polyglot = {
        { "detect",  { "generate[repo]" } },
        { "setup",   { "setup[app]" } },
        { "compile", { "compile[app]" } },
        { "bundle",  { "bundle[app]" } },
        { "test",    { "test[test]" } },
    },

    -- Full CI: all languages, all quality checks
    polyglot_all = {
        { "detect",  { "generate[repo]" } },
        { "setup",   { "setup[app]", "setup[coverage]", "setup[fuzz]" } },
        { "compile", { "compile[app]", "compile[coverage]", "compile[fuzz]" } },
        { "bundle",  { "bundle[app]", "bundle[coverage]", "bundle[fuzz]" } },
        { "test",    { "test[test]", "test[coverage]", "test[fuzz]" } },
        { "quality", { "quality[lint]", "quality[format]", "quality[analyze]" } },
        { "verify",  { "verify[security]", "verify[audit]" } },
    },

    -- Quick iteration: compile + test only
    polyglot_quick = {
        { "compile", { "compile[app]" } },
        { "test",    { "test[test]" } },
    },

    polyglot_run = {
        { "setup",   { "setup[app]" } },
        { "compile", { "compile[app]" } },
        { "bundle",  { "bundle[app]" } },
        { "run",     { "run[app]" } },
    },

    polyglot_debug = {
        { "setup",   { "setup[debug]" } },
        { "compile", { "compile[debug]" } },
        { "bundle",  { "bundle[debug]" } },
        { "run",     { "run[debug]" } },
    },

    -- Go-only shortcut (when go plugin loaded)
    polyglot_go = {
        { "setup",   { "setup[app]" } },
        { "compile", { "compile[app]" } },
        { "bundle",  { "bundle[app]" } },
        { "test",    { "test[test]" } },
    },

    -- Rust-only shortcut (when cargo plugin loaded)
    polyglot_rust = {
        { "setup",   { "setup[app]" } },
        { "compile", { "compile[app]" } },
        { "bundle",  { "bundle[app]" } },
        { "test",    { "test[test]" } },
    },

    -- C++ shortcut (when conan/clang plugins loaded)
    polyglot_cpp = {
        { "setup",   { "setup[app]" } },
        { "compile", { "compile[app]" } },
        { "bundle",  { "bundle[app]" } },
        { "test",    { "test[test]" } },
    },
}

tasks {
    detect = {
        { plugin = "coditary/polyglot", step = "polyglot:detect" },
    },
}
