local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.setup_dune(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ocaml-setup"

    return table.concat({
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        cfg.dune_binary,
        "build",
        "--dry-run",
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.setup_ocamlc(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ocaml-setup"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bytecode_dir),
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

    return M.setup_ocamlc(cfg, root)
end

function M.compile_dune(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bytecode_dir),
        "&&",
        cfg.dune_binary,
        "build",
        cfg.dune_build_target,
    }

    if cfg.build_mode == "debug" then
        parts[#parts + 1] = "--verbose"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find _build -name '*.bc' -exec cp -a {} "
        .. beez.char.quote(root .. "/" .. cfg.bin_dir) .. "/ \\; 2>/dev/null || true"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find _build -name '*.cmo' -exec cp -a {} "
        .. beez.char.quote(root .. "/" .. cfg.bytecode_dir) .. "/ \\; 2>/dev/null || true"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find _build -name '*.cma' -exec cp -a {} "
        .. beez.char.quote(root .. "/" .. cfg.bytecode_dir) .. "/ \\; 2>/dev/null || true"

    return table.concat(parts, " ")
end

function M.compile_ocamlc(cfg, root)
    if #cfg.sources == 0 then
        error("ocamlc plugin: no OCaml source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(root .. "/" .. source)
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bytecode_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.ocamlc_binary,
        "-I",
        beez.char.quote(root .. "/" .. cfg.bytecode_dir),
    }

    for _, arg in ipairs(cfg.ocamlc_args) do
        parts[#parts + 1] = arg
    end

    parts[#parts + 1] = "-o"
    parts[#parts + 1] = beez.char.quote(root .. "/" .. cfg.primary_output)

    for _, source in ipairs(quoted_sources) do
        parts[#parts + 1] = source
    end

    return table.concat(parts, " ")
end

function M.compile(cfg, root)
    if cfg.backend == "dune" then
        return M.compile_dune(cfg, root)
    end

    return M.compile_ocamlc(cfg, root)
end

function M.verify_dune(cfg, root)
    local checks = {
        "test -d " .. beez.char.quote(root .. "/" .. cfg.bytecode_dir),
    }

    checks[#checks + 1] = "( test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " && find " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " -name '*.bc' | head -1 | grep -q . )"
        .. " || find " .. beez.char.quote(root .. "/" .. cfg.bytecode_dir)
        .. " -name '*.cmo' -o -name '*.cma' | head -1 | grep -q ."

    return table.concat(checks, " && ")
end

function M.verify_ocamlc(cfg, root)
    return "( test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
        .. " || find " .. beez.char.quote(root .. "/" .. cfg.bytecode_dir)
        .. " -name '*.cmo' -o -name '*.cma' | head -1 | grep -q . )"
end

function M.verify(cfg, root)
    if cfg.backend == "dune" then
        return M.verify_dune(cfg, root)
    end

    return M.verify_ocamlc(cfg, root)
end

function M.test_dune(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        cfg.dune_binary,
        cfg.dune_test_target,
    }

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    return table.concat(parts, " ")
end

function M.test_ocamlc(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'ocamlc standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/ocaml-ocamlc.ok"),
    }

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    if cfg.backend == "dune" then
        return M.test_dune(cfg, root)
    end

    return M.test_ocamlc(cfg, root)
end

return M
