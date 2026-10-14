local M = {}

local function project_dir(cfg, root)
    if cfg.project_root == "." or cfg.project_root == "" then
        return root
    end
    return root .. "/" .. cfg.project_root
end

local function quoted_sources(cfg, root)
    local parts = {}
    for _, source in ipairs(cfg.sources) do
        parts[#parts + 1] = beez.char.quote(root .. "/" .. source)
    end
    return table.concat(parts, " ")
end

local function lib_args(cfg, root)
    local parts = {}
    for _, lib_dir in ipairs(cfg.lib_dirs) do
        parts[#parts + 1] = "-lib:" .. beez.char.quote(root .. "/" .. lib_dir)
    end
    return table.concat(parts, " ")
end

local function reference_args(cfg, root)
    local parts = {}
    for _, reference in ipairs(cfg.references) do
        parts[#parts + 1] = "-r:" .. beez.char.quote(root .. "/" .. reference)
    end
    return table.concat(parts, " ")
end

function M.setup(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.mcs-setup-ok"
    local compiler = cfg.compiler_binary or cfg.mcs_binary
    return table.concat({
        "command -v " .. beez.char.quote(compiler),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local compiler = cfg.compiler_binary or cfg.mcs_binary
    local target = "exe"
    if cfg.meta ~= nil and cfg.meta.output_type ~= nil and cfg.meta.output_type:lower() == "library" then
        target = "library"
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "cd " .. beez.char.quote(project_dir(cfg, root)),
        "&&",
        compiler,
        "-out:" .. beez.char.quote(root .. "/" .. cfg.primary_output),
        "-target:" .. target,
    }

    if cfg.optimize then
        parts[#parts + 1] = "-optimize+"
    end

    if cfg.debug_symbols then
        parts[#parts + 1] = "-debug"
    end

    local libs = lib_args(cfg, root)
    if libs ~= "" then
        parts[#parts + 1] = libs
    end

    local refs = reference_args(cfg, root)
    if refs ~= "" then
        parts[#parts + 1] = refs
    end

    parts[#parts + 1] = quoted_sources(cfg, root)
    return table.concat(parts, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local stamp = root .. "/" .. cfg.reports_dir .. "/test/mcs-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
    }

    if cfg.test_output ~= nil then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.test_runner
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.test_output)
    elseif cfg.meta ~= nil and cfg.meta.output_type ~= nil and cfg.meta.output_type:lower() == "exe" then
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.mono_binary
        parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.primary_output)
    else
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "echo 'mcs: no test assembly or executable target — skipping tests'"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(stamp)
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
