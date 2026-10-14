local detect = require("src.detect")
local defaults = require("src.defaults")

local M = {}

function M.detect(ctx)
    local detected = detect.detect_all(ctx)
    local report = detect.format_report(detected)

    print(defaults.log_prefix_detect .. " " .. report)

    local report_path = defaults.reports_dir .. "/polyglot/detect.txt"
    local write_cmd = "mkdir -p " .. beez.char.quote(ctx.project_root .. "/" .. defaults.reports_dir .. "/polyglot") ..
        " && printf %s " .. beez.char.quote(report) .. " > " .. beez.char.quote(ctx.project_root .. "/" .. report_path)

    local code = beez.shell.run(ctx, defaults.log_prefix_detect, write_cmd)
    if code ~= 0 then
        return code
    end

    return 0
end

return M
