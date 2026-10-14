local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_terraform(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.terraform-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.terraform_binary,
        "version",
        "&&",
        cfg.terraform_binary,
        "init",
        "-backend=false",
        "-input=false",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local plan_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.plan_output
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.terraform_binary,
        "validate",
        "&&",
        cfg.terraform_binary,
        "plan",
        "-input=false",
        "-out",
        beez.char.quote(plan_file),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end

function M.verify_output(cfg, root)
    local plan_file = root .. "/" .. cfg.bin_dir .. "/" .. cfg.plan_output
    return table.concat({
        "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "&&",
        "test -f " .. beez.char.quote(plan_file),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/terraform-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.terraform_binary
        parts[#parts + 1] = "fmt"
        parts[#parts + 1] = "-check"
        parts[#parts + 1] = "-recursive"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.terraform_binary
        parts[#parts + 1] = "validate"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = cfg.terraform_binary
        parts[#parts + 1] = "fmt"
        parts[#parts + 1] = "-check"
        parts[#parts + 1] = "-recursive"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
