local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

function M.fetch(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.zig-configured"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&& cd " .. beez.char.quote(project_dir(cfg, root)),
    }

    if cfg.has_zon then
        parts[#parts + 1] = "&& " .. cfg.zig_binary .. " build --fetch"
    end

    parts[#parts + 1] = "&& touch " .. beez.char.quote(stamp)
    return table.concat(parts, " ")
end

function M.build(cfg, root)
    return table.concat({
        "cd " .. beez.char.quote(project_dir(cfg, root)),
        "&& " .. cfg.zig_binary .. " build -Doptimize=" .. cfg.optimize,
    }, " ")
end

function M.verify(cfg, root)
    local bin_root = root .. "/" .. cfg.bin_dir
    return table.concat({
        "test -d " .. beez.char.quote(bin_root),
        "&& test -n \"$(ls -A " .. beez.char.quote(bin_root) .. " 2>/dev/null)\"",
    }, " ")
end

function M.test(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/zig-" .. cfg.profile_name .. ".ok"
    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&& cd " .. beez.char.quote(project_dir(cfg, root)),
        "&& " .. cfg.zig_binary .. " build test -Doptimize=" .. cfg.optimize,
        "&& touch " .. beez.char.quote(stamp),
    }, " ")
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
