local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.smlnj-setup"

    return table.concat({
        "command -v " .. cfg.smlnj_binary,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_target(cfg, root, target)
    local cm_file = cfg.manifest_path or "sources.cm"
    local stamp = root .. "/" .. cfg.compile_stamp

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "(test -f " .. beez.char.quote(cm_file) .. " && echo 'CM.make " .. beez.char.quote(cm_file) .. ";' | " .. cfg.smlnj_binary,
        "|| echo 'use " .. beez.char.quote(target.source) .. ";' | " .. cfg.smlnj_binary .. ")",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_all(cfg, root)
    
function M.run(cfg, root)
    local run_args = beez.env_or("BEEZ_RUN_ARGS", cfg.run_args or "")

    if cfg.run_command ~= nil and cfg.run_command ~= "" then
        if run_args ~= "" then
            return cfg.run_command .. " " .. run_args
        end
        return cfg.run_command
    end

    if cfg.primary_source ~= nil then
        local interpreter = cfg.interpreter_binary
        if interpreter == nil or interpreter == "" then
            error("run: primary_source set but no interpreter_binary in config")
        end
        local parts = {}
        if cfg.project_root ~= nil and cfg.project_root ~= "." and cfg.project_root ~= "" then
            parts[#parts + 1] = "cd " .. beez.char.quote(root .. "/" .. cfg.project_root)
            parts[#parts + 1] = "&&"
        end
        parts[#parts + 1] = interpreter
        parts[#parts + 1] = cfg.primary_source
        if run_args ~= "" then
            parts[#parts + 1] = run_args
        end
        return table.concat(parts, " ")
    end

    if cfg.primary_output ~= nil then
        local exe = root .. "/" .. cfg.primary_output
        local parts = {
            "(",
            "test -x " .. beez.char.quote(exe),
            "||",
            "test -f " .. beez.char.quote(exe),
            ")",
            "&&",
            beez.char.quote(exe),
        }
        if run_args ~= "" then
            parts[#parts + 1] = run_args
        end
        return table.concat(parts, " ")
    end

    if cfg.build_tree ~= nil then
        local bin_dir = root .. "/" .. cfg.build_tree .. "/bin"
        local shell = "set -e; bin=$(find "
            .. beez.char.quote(bin_dir)
            .. " -type f \\( -perm -111 -o -name '*.wasm' -o -name '*.js' \\) 2>/dev/null | head -n1); "
            .. "if [ -z \"$bin\" ]; then echo 'run: no executable in "
            .. cfg.build_tree
            .. "/bin' >&2; exit 1; fi; exec \"$bin\""
        if run_args ~= "" then
            shell = shell .. " " .. run_args
        end
        return "sh -c " .. beez.char.quote(shell)
    end

    error("run: no run target configured")
end

return M.compile_target(cfg, root, cfg.targets[1])
end

function M.verify_artifacts(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.compile_stamp)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/smlnj-" .. cfg.profile_name .. ".ok"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "test -f " .. beez.char.quote(root .. "/" .. cfg.compile_stamp),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }, " ")
end


return M
