local M = {}

M.reports_dir = "report"
M.coverage_build_tree = "build/build/Coverage"
M.build_dir = "build"
M.report_script = "scripts/coverage-report.sh"
M.min_line_coverage = "85"

M.report_html = "report/coverage/index.html"
M.coverage_test_ok = "report/test/coverage-test-report.ok"

M.log_prefix = "[coverage-report]"

M.report_rev = "1"

return M
