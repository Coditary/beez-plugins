local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.pip_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.qiskit-setup"

    if not cfg.has_requirements then
        return table.concat({
            project_cd(cfg, root),
            "&&",
            cfg.python_binary,
            "-c",
            beez.char.quote("import qiskit"),
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.pip_binary,
        "install",
        "-r",
        beez.char.quote(cfg.requirements_path),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.transpile(cfg, root)
    local output = root .. "/" .. cfg.primary_output
    local entry = cfg.entry_source
    if entry == nil then
        error("qiskit plugin: no *.qasm entry source found")
    end

    local script = table.concat({
        "from qiskit import qasm3",
        "from qiskit import transpile",
        "from qiskit.qasm3 import loads",
        "import pathlib",
        "src = pathlib.Path(" .. beez.char.quote(entry) .. ")",
        "circuit = loads(src.read_text())",
        "transpiled = transpile(circuit)",
        "out = pathlib.Path(" .. beez.char.quote(output) .. ")",
        "out.parent.mkdir(parents=True, exist_ok=True)",
        "out.write_text(qasm3.dumps(transpiled))",
    }, "; ")

    return table.concat({
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        cfg.python_binary,
        "-c",
        beez.char.quote(script),
    }, " ")
end

function M.verify_output(cfg, root)
    return "test -f " .. beez.char.quote(root .. "/" .. cfg.primary_output)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/qiskit-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.python_binary
        parts[#parts + 1] = "-m"
        parts[#parts + 1] = "pytest"
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
