local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_cue(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.cue-setup"
    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.cue_binary,
        "version",
        "&&",
    }

    if cfg.has_module then
        parts[#parts + 1] = cfg.cue_binary
        parts[#parts + 1] = "mod"
        parts[#parts + 1] = "tidy"
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local ok_file = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.entry_source ~= nil then
        parts[#parts + 1] = cfg.cue_binary
        parts[#parts + 1] = "vet"
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.cue_binary
        parts[#parts + 1] = "export"
        parts[#parts + 1] = "--outfile"
        parts[#parts + 1] = beez.char.quote(ok_file)
        parts[#parts + 1] = beez.char.quote(cfg.entry_source)
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = "test -s " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/cue-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.cue_binary
        parts[#parts + 1] = "vet"
        parts[#parts + 1] = "./..."
        parts[#parts + 1] = "&&"
    end

    parts[#parts + 1] = cfg.cue_binary
    parts[#parts + 1] = "fmt"
    parts[#parts + 1] = "--check"
    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

    return table.concat(parts, " ")
end

function M.run(cfg, root)
    local run_args = beez.env_or("BEEZ_RUN_ARGS", cfg.run_args or "")

    if cfg.run_command ~= nil and cfg.run_command ~= "" then
        if run_args ~= "" then
            return cfg.run_command .. " " .. run_args
        end
        return cfg.run_command
    end

    if cfg.entry_source == nil then
        error("cue run: no entry_source configured")
    end

    local parts = {
        project_cd(cfg, root),
        "&&",
        cfg.cue_binary,
        "eval",
    }

    if run_args ~= "" then
        parts[#parts + 1] = run_args
    end

    parts[#parts + 1] = beez.char.quote(cfg.entry_source)
    return table.concat(parts, " ")
end

return M
