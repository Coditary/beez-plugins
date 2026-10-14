local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

local function join_flags(flags)
    if flags == nil or #flags == 0 then
        return ""
    end
    return table.concat(flags, " ")
end

local function gdc_opt_flags(cfg)
    local parts = {}
    if cfg.optimize then
        parts[#parts + 1] = "-O2"
    end
    if cfg.debug_symbols then
        parts[#parts + 1] = "-g"
    end
    local extra = join_flags(cfg.gdc_flags)
    if extra ~= "" then
        parts[#parts + 1] = extra
    end
    return table.concat(parts, " ")
end

function M.deps_fetch(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.gdc-deps-fetched"
    local dir = project_dir(cfg, root)

    if not cfg.uses_dub then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&& touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&& cd " .. beez.char.quote(dir),
        "&& " .. cfg.dub_binary .. " fetch",
        "&& touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.build_dub_target(cfg, root, target)
    local dir = project_dir(cfg, root)
    local output = root .. "/" .. target.output
    local dub_extra = join_flags(cfg.dub_flags)

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&& cd " .. beez.char.quote(dir),
        "&& " .. cfg.dub_binary .. " build",
        "--compiler=" .. cfg.gdc_binary,
        "--build=" .. cfg.dub_build,
        dub_extra,
        "&& PKG=$(" .. cfg.dub_binary .. " describe --data=name | head -1)",
        "&& install -D " .. beez.char.quote(dir) .. "/$PKG " .. beez.char.quote(output),
    }, " ")
end

function M.build_plain_target(cfg, root, target)
    local dir = project_dir(cfg, root)
    local output = root .. "/" .. target.output
    local sources = table.concat(target.sources, " ")
    local flags = gdc_opt_flags(cfg)

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&& cd " .. beez.char.quote(dir),
        "&& " .. cfg.gdc_binary,
        flags,
        "-o " .. beez.char.quote(output),
        sources,
    }, " ")
end

function M.build_target(cfg, root, target)
    if target.kind == "dub" then
        
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

return M.build_dub_target(cfg, root, target)
    end
    return M.build_plain_target(cfg, root, target)
end

function M.build_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.build_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -f " .. beez.char.quote(root .. "/" .. target.output)
    end
    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local dir = project_dir(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/gdc-" .. cfg.profile_name .. ".ok"

    if cfg.uses_dub then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&& cd " .. beez.char.quote(dir),
            "&& " .. cfg.dub_binary .. " test",
            "--compiler=" .. cfg.gdc_binary,
            "--build=" .. cfg.dub_build,
            cfg.test_args,
            "&& touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&& echo 'gdc plain project: no dub test runner configured'",
        "&& touch " .. beez.char.quote(stamp),
    }, " ")
end

return M
