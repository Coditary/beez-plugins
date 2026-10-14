local defaults = require("src.defaults")
local env = require("src.env")
local step_config = require("src.step_config")

local reports_dir = env.env_or("REPORTS_DIR", defaults.reports_dir)
local debug_tree = defaults.coverage_build_tree or "build/build/Coverage"

-- Beez coverage plugin
--
-- Steps:
--   report:coverage — gcovr HTML report + minimum line coverage gate
--
-- Pair with coditary/conan (configure:coverage, build:coverage) and
-- coditary/ctest (test:coverage).
--
-- Env: REPORTS_DIR, MIN_LINE_COVERAGE (default 85)
--
-- reqpack {
--     beez = {
--         {
--             name = "coditary/coverage",
--             path = "./plugins/coditary/coverage",
--             version = "1.0.0",
--         },
--     },
-- }

plugin("coverage", {
    version = "1.0.0",
    description = "Coverage HTML report and threshold enforcement",
    organization = "coditary",

    steps = {
        ["report:coverage"] = {
            phase = "package",
            scope = "coverage",
            input = {
                debug_tree .. "/tests/unit/beez_tests",
                "src/**/*.cpp",
                reports_dir .. "/test/coverage-test-report.ok",
                debug_tree .. "/**/*.gcda",
            },
            output = { reports_dir .. "/coverage/index.html" },
            description = "Generate HTML coverage report and enforce minimum line coverage",
            config = step_config.report_defaults(),
            run = function(ctx)
                return require("src.runner").report(ctx)
            end,
        },
    },
})
