local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function dune_invocation(cfg)
    return cfg.dune_binary .. " --root ."
end

local function copy_js_artifacts(root, cfg)
    local js_dir = beez.char.quote(root .. "/" .. cfg.js_dir)
    local bin_dir = beez.char.quote(root .. "/" .. cfg.bin_dir)

    return table.concat({
        "if [ -d _build ]; then",
        "find _build -type f \\( -name '*.js' -o -name '*.bc.js' \\) -exec cp -a {} " .. js_dir .. "/ \\;;",
        "fi",
        "&&",
        "if [ -d _build ]; then",
        "find _build -type f -name '*.js.map' -exec cp -a {} " .. js_dir .. "/ \\;;",
        "fi",
        "&&",
        "if [ -d _build ]; then",
        "find _build -type f -name '*.bc' -exec cp -a {} " .. bin_dir .. "/ \\;;",
        "fi",
    }, " ")
end

function M.setup_dune(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.jsoo-setup"
    local dune = dune_invocation(cfg)

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        dune,
        "build",
        "@install",
        "--dry-run",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup_js_of_ocaml(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.jsoo-setup"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup(cfg, root)
    if cfg.backend == "dune" then
        
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

return M.setup_dune(cfg, root)
    end

    return M.setup_js_of_ocaml(cfg, root)
end

function M.compile_dune(cfg, root)
    local dune = dune_invocation(cfg)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        dune,
        "build",
        "--profile",
        cfg.dune_profile,
        cfg.dune_compile_target,
        "&&",
        copy_js_artifacts(root, cfg),
    }

    return table.concat(parts, " ")
end

function M.compile_js_of_ocaml(cfg, root)
    if #cfg.sources == 0 then
        error("js-of-ocaml plugin: no OCaml source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(root .. "/" .. source)
    end

    local bc_output = root .. "/" .. cfg.bin_dir .. "/" .. cfg.profile_name .. ".bc"
    local js_output = root .. "/" .. cfg.primary_output
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.js_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.ocamlfind_binary,
        "ocamlc",
        "-o",
        beez.char.quote(bc_output),
        "-linkall",
        "-package",
        "js_of_ocaml",
        table.concat(quoted_sources, " "),
        "&&",
        cfg.jsoo_binary,
        beez.char.quote(bc_output),
        "-o",
        beez.char.quote(js_output),
    }

    for _, arg in ipairs(cfg.jsoo_args) do
        parts[#parts + 1] = arg
    end

    if cfg.source_map then
        parts[#parts + 1] = "--sourcemap"
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    if cfg.backend == "dune" then
        return M.compile_dune(cfg, root)
    end

    return M.compile_js_of_ocaml(cfg, root)
end

function M.verify_dune(cfg, root)
    local checks = {
        "test -d " .. beez.char.quote(root .. "/" .. cfg.js_dir),
    }

    checks[#checks + 1] = "( find " .. beez.char.quote(root .. "/" .. cfg.js_dir)
        .. " -name '*.js' | head -1 | grep -q . )"
        .. " || ( test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " && find " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " -name '*.js' | head -1 | grep -q . )"

    return table.concat(checks, " && ")
end

function M.verify_js_of_ocaml(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.verify(cfg, root)
    if cfg.backend == "dune" then
        return M.verify_dune(cfg, root)
    end

    return M.verify_js_of_ocaml(cfg, root)
end

function M.test_dune(cfg, root)
    local dune = dune_invocation(cfg)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        dune,
        "build",
        cfg.dune_test_target,
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch "
        .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/js-of-ocaml-" .. cfg.profile_name .. ".ok")

    return table.concat(parts, " ")
end

function M.test_js_of_ocaml(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'js_of_ocaml standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/js-of-ocaml.ok"),
    }

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    if cfg.backend == "dune" then
        return M.test_dune(cfg, root)
    end

    return M.test_js_of_ocaml(cfg, root)
end

return M
