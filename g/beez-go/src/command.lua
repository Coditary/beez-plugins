local M = {}

local function mod_dir(cfg, root)
    if cfg.module_root == "." or cfg.module_root == "" then
        return root
    end
    return root .. "/" .. cfg.module_root
end

local function tags_arg(cfg)
    if cfg.tags == nil or #cfg.tags == 0 then
        return ""
    end
    return "-tags=" .. beez.char.quote(table.concat(cfg.tags, ","))
end

function M.mod_download(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.go-mod-downloaded"
    return table.concat({
        cfg.env_prefix,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "cd " .. beez.char.quote(mod_dir(cfg, root)),
        "&&",
        cfg.go_binary,
        "mod download",
        "&&",
        cfg.go_binary,
        "mod verify",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_target(cfg, root, target)
    local parts = {
        cfg.env_prefix,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "cd " .. beez.char.quote(mod_dir(cfg, root)),
        "&&",
        cfg.go_binary,
        "build",
    }

    if cfg.trimpath then
        parts[#parts + 1] = "-trimpath"
    end

    if cfg.ldflags ~= nil and cfg.ldflags ~= "" then
        parts[#parts + 1] = "-ldflags=" .. beez.char.quote(cfg.ldflags)
    end

    if cfg.gcflags ~= nil and cfg.gcflags ~= "" then
        parts[#parts + 1] = "-gcflags=" .. beez.char.quote(cfg.gcflags)
    end

    local tags = tags_arg(cfg)
    if tags ~= "" then
        parts[#parts + 1] = tags
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. target.output)
    parts[#parts + 1] = target.package

    return table.concat(parts, " ")
end

function M.build_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.install_stamp(cfg, root)
    local outputs = {}
    for _, target in ipairs(cfg.targets) do
        outputs[#outputs + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(outputs, " && ")
end

function M.test(cfg, root)
    local parts = {
        cfg.env_prefix,
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "cd " .. beez.char.quote(mod_dir(cfg, root)),
        "&&",
        cfg.go_binary,
        "test",
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = cfg.test_packages
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
