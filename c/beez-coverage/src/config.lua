local defaults = require("src.defaults")
local env = require("src.env")

local M = {}

function M.resolve(config)
    local cfg = config or {}

    return {
        reports_dir = cfg.reports_dir or env.env_or("REPORTS_DIR", defaults.reports_dir),
        debug_build_tree = cfg.debug_build_tree or defaults.debug_build_tree,
        build_dir = cfg.build_dir or defaults.build_dir,
        report_script = cfg.report_script or defaults.report_script,
        min_line_coverage = cfg.min_line_coverage or env.env_or("MIN_LINE_COVERAGE", defaults.min_line_coverage),
        report_html = cfg.report_html or defaults.report_html,
        coverage_test_ok = cfg.coverage_test_ok or defaults.coverage_test_ok,
        log_prefix = cfg.log_prefix or defaults.log_prefix,
        report_rev = cfg.report_rev or defaults.report_rev,
    }
end

return M
