local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function r_binary(cfg)
    return "(command -v " .. cfg.cxxr_binary .. " >/dev/null 2>&1 && echo " .. cfg.cxxr_binary .. " || echo " .. cfg.r_fallback_binary .. ")"
end

function M.install_deps(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.cxxr-setup"

    if not cfg.has_description then
        return table.concat({
            "RBIN=$( " .. r_binary(cfg) .. " )",
            "&&",
            "command -v \"$RBIN\"",
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        "RBIN=$( " .. r_binary(cfg) .. " )",
        "&&",
        "command -v \"$RBIN\"",
        "&&",
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "\"$RBIN\" CMD INSTALL deps",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir

    if not cfg.has_description then
        error("cxxr plugin: R CMD build requires DESCRIPTION — add an R package manifest")
    end

    return table.concat({
        "RBIN=$( " .. r_binary(cfg) .. " )",
        "&&",
        "command -v \"$RBIN\"",
        "&&",
        "mkdir -p " .. beez.char.quote(dest),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$RBIN\" CMD build --output=" .. beez.char.quote(dest) .. " .",
    }, " ")
end

function M.verify_tarball(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir
    return table.concat({
        "test -d " .. beez.char.quote(dest),
        "&&",
        "test -n \"$(find " .. beez.char.quote(dest) .. " -name '*.tar.gz' -print -quit 2>/dev/null)\"",
    }, " ")
end

function M.check(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/cxxr-" .. cfg.profile_name .. ".ok"

    if not cfg.has_description then
        error("cxxr plugin: R CMD check requires DESCRIPTION — add an R package manifest")
    end

    local parts = {
        "RBIN=$( " .. r_binary(cfg) .. " )",
        "&&",
        "command -v \"$RBIN\"",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$RBIN\" CMD check",
    }

    if cfg.check_args ~= nil and cfg.check_args ~= "" then
        parts[#parts + 1] = cfg.check_args
    end

    parts[#parts + 1] = "."
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

return M
