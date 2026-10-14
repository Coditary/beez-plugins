local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function relative_path(cfg, path)
    if path == nil then
        return nil
    end

    if cfg.project_root == "." or cfg.project_root == "" then
        return path
    end

    local prefix = cfg.project_root .. "/"
    if path:sub(1, #prefix) == prefix then
        return path:sub(#prefix + 1)
    end

    return path
end

local function build_output_dir(cfg, root)
    return root .. "/" .. cfg.build_dir
end

local function ensure_build_dir(cfg, root)
    return "mkdir -p " .. beez.char.quote(build_output_dir(cfg, root))
end

local function setup_stamp(cfg, root)
    return root .. "/" .. cfg.build_dir .. "/.pharo-setup"
end

local function vm_command(cfg)
    return "(command -v " .. cfg.pharo_binary .. " >/dev/null 2>&1 && echo " .. cfg.pharo_binary .. " || echo " .. cfg.squeak_binary .. ")"
end

function M.verify_vm(cfg, root)
    local stamp = setup_stamp(cfg, root)

    return table.concat({
        ensure_build_dir(cfg, root),
        "&&",
        "VM=$(" .. vm_command(cfg) .. ")",
        "&&",
        "command -v \"$VM\"",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.headless(cfg, root, script_path, eval_expr)
    local vm = "$(" .. vm_command(cfg) .. ")"
    local parts = {
        project_cd(cfg, root),
        "&&",
        "VM=" .. vm,
        "&&",
    }

    if cfg.has_image then
        local image = beez.char.quote(relative_path(cfg, cfg.image_path))
        parts[#parts + 1] = "\"$VM\""
        parts[#parts + 1] = "--headless"
        parts[#parts + 1] = image
    else
        parts[#parts + 1] = "\"$VM\""
        parts[#parts + 1] = "--headless"
    end

    if script_path ~= nil then
        parts[#parts + 1] = beez.char.quote(relative_path(cfg, script_path))
    elseif eval_expr ~= nil then
        parts[#parts + 1] = "eval"
        parts[#parts + 1] = beez.char.quote(eval_expr)
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    local stamp = build_output_dir(cfg, root) .. "/.compiled"

    if cfg.compile_script ~= nil then
        return table.concat({
            ensure_build_dir(cfg, root),
            "&&",
            M.headless(cfg, root, cfg.compile_script, nil),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    if cfg.has_image then
        return table.concat({
            ensure_build_dir(cfg, root),
            "&&",
            M.headless(cfg, root, nil, "SmalltalkImage current snapshot: false; SystemNavigation new allBehaviorsDo: [:b | b methodsDo: [:m | m recompile]]. SmalltalkImage current snapshot: true"),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    local filein_cmds = {}
    for _, source in ipairs(cfg.source_files or {}) do
        local rel = relative_path(cfg, source)
        filein_cmds[#filein_cmds + 1] = M.headless(cfg, root, rel, nil)
    end

    if #filein_cmds == 0 then
        return ensure_build_dir(cfg, root) .. " && touch " .. beez.char.quote(stamp)
    end

    return table.concat({
        ensure_build_dir(cfg, root),
        "&&",
        table.concat(filein_cmds, " && "),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.verify_artifacts(cfg, root)
    local stamp = build_output_dir(cfg, root) .. "/.compiled"
    return "test -f " .. beez.char.quote(stamp)
end

function M.test(cfg, root)
    local report = root .. "/" .. cfg.reports_dir .. "/test/pharo-" .. cfg.profile_name .. ".ok"

    if cfg.test_script ~= nil then
        local parts = {
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            M.headless(cfg, root, cfg.test_script, nil),
            "&&",
            "touch " .. beez.char.quote(report),
        }
        return table.concat(parts, " ")
    end

    if cfg.has_image and cfg.has_tests then
        return table.concat({
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
            "&&",
            M.headless(cfg, root, nil, "[TestRunner run: TestCase allSubclasses select: [:c | c includesSelector: #testSomething]] ifNotNil: [:r | r run]"),
            "&&",
            "touch " .. beez.char.quote(report),
        }, " ")
    end

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "touch " .. beez.char.quote(report),
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
