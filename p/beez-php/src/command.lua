local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.composer_install(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.php-setup"

    if not cfg.has_composer then
        return table.concat({
            "command -v " .. cfg.php_binary,
            "&&",
            "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
            "&&",
            "touch " .. beez.char.quote(stamp),
        }, " ")
    end

    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.composer_binary,
        "install",
        "--no-interaction",
        "--prefer-dist",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile_opcache(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir
    local stamp = dest .. "/.compiled"

    local opcache_php = table.concat({
        "$it = new RecursiveIteratorIterator(new RecursiveDirectoryIterator('.', FilesystemIterator::SKIP_DOTS));",
        "foreach ($it as $f) {",
        "  if ($f->getExtension() !== 'php') continue;",
        "  $p = str_replace(chr(92), '/', $f->getPathname());",
        "  if (preg_match('#" .. cfg.compile_exclude .. "#', $p)) continue;",
        "  opcache_compile_file($f->getPathname());",
        "}",
        "file_put_contents('" .. stamp:gsub("'", "\\'") .. "', 'ok');",
    }, " ")

    return table.concat({
        "mkdir -p " .. beez.char.quote(dest),
        "&&",
        project_cd(cfg, root),
        "&&",
        "find . -name '*.php'",
        "-not -path '*/vendor/*'",
        "-not -path '*/build/*'",
        "-not -path '*/.git/*'",
        "-not -path '*/node_modules/*'",
        "-print0 | while IFS= read -r -d '' f; do",
        cfg.php_binary,
        "-l \"$f\" || exit 1;",
        "done",
        "&&",
        cfg.php_binary,
        "-d opcache.enable_cli=1",
        "-d opcache.file_cache=" .. beez.char.quote(dest),
        "-d opcache.file_cache_only=1",
        "-r",
        beez.char.quote(opcache_php),
    }, " ")
end

function M.verify_bytecode(cfg, root)
    local dest = root .. "/" .. cfg.bin_dir
    return table.concat({
        "test -d " .. beez.char.quote(dest),
        "&&",
        "test -f " .. beez.char.quote(dest .. "/.compiled"),
    }, " ")
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/php-" .. cfg.profile_name .. ".ok"

    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_composer then
        parts[#parts + 1] = "test -x vendor/bin/phpunit"
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "vendor/bin/phpunit"
    else
        parts[#parts + 1] = "command -v " .. cfg.phpunit_binary
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = cfg.phpunit_binary
    end

    if cfg.test_args ~= nil and cfg.test_args ~= "" then
        parts[#parts + 1] = cfg.test_args
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)

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
