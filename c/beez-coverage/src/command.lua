local shell = require("src.shell")

local M = {}

function M.report(config, root)
    local script = root .. "/" .. config.report_script

    local parts = {
        "MIN_LINE_COVERAGE=" .. shell.quote(config.min_line_coverage),
        shell.quote(script),
        shell.quote(config.build_dir),
        shell.quote(config.reports_dir),
    }

    return table.concat(parts, " ")
end

return M
