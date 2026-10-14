local defaults = require("src.defaults")

local M = {}

function M.report_defaults()
    return {
        report_rev = defaults.report_rev,
        log_prefix = defaults.log_prefix,
    }
end

return M
