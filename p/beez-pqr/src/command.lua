local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

local function pqr_binary(cfg)
    return "(command -v " .. cfg.pqr_binary .. " >/dev/null 2>&1 && echo " .. cfg.pqr_binary .. " || echo " .. cfg.pqr_fallback_binary .. ")"
end

function M.install_deps(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.pqr-setup"
    local lib = root .. "/" .. cfg.lib_dir
    local r_bin = pqr_binary(cfg)

    if not cfg.has_package then
        return table.concat({
            "R_BIN=$( " .. r_bin .. " )",
            "&&",
            "command -v \"$R_BIN\"",
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        "R_BIN=$( " .. r_bin .. " )",
        "&&",
        "command -v \"$R_BIN\"",
        "&&",
        "mkdir -p " .. beez.char.quote(lib),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$R_BIN\" --slave -e",
        beez.char.quote(table.concat({
            "lib <- " .. beez.char.quote(lib) .. ";",
            "dir.create(lib, recursive = TRUE, showWarnings = FALSE);",
            "if (!requireNamespace(\"remotes\", quietly = TRUE)) {",
            "  install.packages(\"remotes\", lib = lib, repos = \"" .. cfg.cran_repos .. "\")",
            "};",
            "remotes::install_deps(dependencies = TRUE, lib = lib, repos = \"" .. cfg.cran_repos .. "\")",
        }, " ")),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_target(cfg, root, target)
    local r_bin = pqr_binary(cfg)
    local lib = root .. "/" .. cfg.lib_dir

    if target.kind == "package" then
        return table.concat({
            "R_BIN=$( " .. r_bin .. " )",
            "&&",
            "command -v \"$R_BIN\"",
            "&&",
            "mkdir -p " .. beez.char.quote(lib),
            "&&",
            project_cd(cfg, root),
            "&&",
            "\"$R_BIN\" CMD INSTALL --library=" .. beez.char.quote(lib) .. " .",
        }, " ")
    end

    local output_path = root .. "/" .. target.output
    return table.concat({
        "R_BIN=$( " .. r_bin .. " )",
        "&&",
        "command -v \"$R_BIN\"",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$R_BIN\" --slave -e",
        beez.char.quote("compile(" .. beez.char.quote(target.source) .. ", " .. beez.char.quote(output_path) .. ")"),
    }, " ")
end

function M.compile_all(cfg, root)
    local commands = {}
    for _, target in ipairs(cfg.targets) do
        commands[#commands + 1] = M.compile_target(cfg, root, target)
    end
    return table.concat(commands, " && ")
end

function M.verify_artifacts(cfg, root)
    local checks = {}
    for _, target in ipairs(cfg.targets) do
        checks[#checks + 1] = "test -e " .. beez.char.quote(root .. "/" .. target.output)
    end

    if #checks == 0 then
        checks[#checks + 1] = "test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
    end

    return table.concat(checks, " && ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/pqr-" .. cfg.profile_name .. ".ok"
    local r_bin = pqr_binary(cfg)
    local lib = root .. "/" .. cfg.lib_dir

    local parts = {
        "R_BIN=$( " .. r_bin .. " )",
        "&&",
        "command -v \"$R_BIN\"",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
        "\"$R_BIN\" --slave -e",
        beez.char.quote(table.concat({
            ".libPaths(c(" .. beez.char.quote(lib) .. ", .libPaths()));",
            "if (dir.exists(\"tests/testthat\")) {",
            "  if (!requireNamespace(\"testthat\", quietly = TRUE)) stop(\"testthat is required for tests/testthat\");",
            "  testthat::test_dir(\"tests/testthat\")",
            "} else if (file.exists(\"tests/testthat.R\")) {",
            "  if (!requireNamespace(\"testthat\", quietly = TRUE)) stop(\"testthat is required for tests/testthat.R\");",
            "  testthat::test_file(\"tests/testthat.R\")",
            "} else {",
            "  cat(\"No testthat tests found\\n\")",
            "}",
        }, " ")),
        "&&",
        "touch " .. beez.char.quote(ok_file),
    }

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
