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

function M.setup_ocamlopt(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.ocaml-setup"

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
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

    return M.setup_ocamlopt(cfg, root)
end

function M.compile_dune(cfg, root)
    local staging = root .. "/" .. cfg.build_dir .. "/staging"
    local bin_dir = root .. "/" .. cfg.bin_dir
    local package = cfg.package_name

    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        "PKG=" .. beez.char.quote(package),
        "&&",
        "if [ -f dune-project ]; then",
        "PKG=$(grep -m1 '(name ' dune-project | sed -E 's/.*\\(name +([^) ]+)\\).*/\\1/' || echo " .. beez.char.quote(package) .. ");",
        "fi",
        "&&",
        cfg.dune_binary,
        "build",
        "-p",
        "$PKG",
    }

    if cfg.build_mode == "debug" then
        parts[#parts + 1] = "--verbose"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "mkdir -p " .. beez.char.quote(staging)
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = cfg.dune_binary
    parts[#parts + 1] = "install"
    parts[#parts + 1] = "-p"
    parts[#parts + 1] = "$PKG"
    parts[#parts + 1] = "--destdir=" .. beez.char.quote(staging)
    parts[#parts + 1] = "--prefix="
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "if [ -d " .. beez.char.quote(staging .. "/bin") .. " ]; then"
    parts[#parts + 1] = "cp -a " .. beez.char.quote(staging .. "/bin") .. "/* " .. beez.char.quote(bin_dir) .. "/;"
    parts[#parts + 1] = "fi"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find _build -type f \\( -perm /111 -o -name '*.exe' \\)"
    parts[#parts + 1] = "-not -path '*/install/*'"
    parts[#parts + 1] = "-exec cp -a {} " .. beez.char.quote(bin_dir) .. "/ \\; 2>/dev/null || true"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find _build -name '*.cmx' -o -name '*.cmxa' -o -name '*.o'"
    parts[#parts + 1] = "| xargs -r -I{} cp -a {} " .. beez.char.quote(root .. "/" .. cfg.obj_dir) .. "/ 2>/dev/null || true"

    return table.concat(parts, " ")
end

function M.compile_ocamlopt(cfg, root)
    if #cfg.sources == 0 then
        error("ocamlopt plugin: no OCaml source files to compile")
    end

    local quoted_sources = {}
    for _, source in ipairs(cfg.sources) do
        quoted_sources[#quoted_sources + 1] = beez.char.quote(root .. "/" .. source)
    end

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.obj_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        cfg.ocamlopt_binary,
        "-I",
        beez.char.quote(root .. "/" .. cfg.obj_dir),
    }

    for _, arg in ipairs(cfg.ocamlopt_args) do
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

    return M.compile_ocamlopt(cfg, root)
end

function M.verify_dune(cfg, root)
    local checks = {
        "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "( find " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
            .. " -type f \\( -perm /111 -o -name '*.exe' \\) | head -1 | grep -q . )"
            .. " || find " .. beez.char.quote(root .. "/" .. cfg.obj_dir)
            .. " -name '*.cmx' -o -name '*.cmxa' | head -1 | grep -q .",
    }

    return table.concat(checks, " && ")
end

function M.verify_ocamlopt(cfg, root)
    return "( test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
        .. " && test -x " .. beez.char.quote(root .. "/" .. cfg.primary_output) .. " )"
        .. " || find " .. beez.char.quote(root .. "/" .. cfg.obj_dir)
        .. " -name '*.cmx' -o -name '*.cmxa' | head -1 | grep -q ."
end

function M.verify(cfg, root)
    if cfg.backend == "dune" then
        return M.verify_dune(cfg, root)
    end

    return M.verify_ocamlopt(cfg, root)
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

function M.test_ocamlopt(cfg, root)
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        "echo 'ocamlopt standalone: no test runner configured; compile-only project'",
        "&&",
        "touch " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test/ocaml-ocamlopt.ok"),
    }

    return table.concat(parts, " ")
end

function M.test(cfg, root)
    if cfg.backend == "dune" then
        return M.test_dune(cfg, root)
    end

    return M.test_ocamlopt(cfg, root)
end

return M
