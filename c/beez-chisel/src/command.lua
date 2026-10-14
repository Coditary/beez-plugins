local M = {}

local function project_cd(cfg, root)
    local dir = root
    if cfg.project_root ~= "." and cfg.project_root ~= "" then
        dir = root .. "/" .. cfg.project_root
    end

    return "cd " .. beez.char.quote(dir)
end

function M.verify_sbt(cfg, root)
    local stamp = root .. "/" .. cfg.build_dir .. "/.chisel-setup"
    return table.concat({
        project_cd(cfg, root),
        "&&",
        cfg.sbt_binary,
        "-batch",
        "-Dsbt.supershell=false",
        "update",
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.build_dir),
        "&&",
        "touch " .. beez.char.quote(stamp),
    }, " ")
end

function M.compile(cfg, root)
    local parts = {
        project_cd(cfg, root),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.bin_dir),
        "&&",
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.classes_dir),
        "&&",
        cfg.sbt_binary,
        "-batch",
        "-Dsbt.supershell=false",
        cfg.sbt_compile_task,
    }

    if cfg.profile_name == "debug" then
        parts[#parts + 1] = "-v"
    end

    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "for d in target/scala-*/classes; do if [ -d \"$d\" ]; then cp -a \"$d\"/. "
        .. beez.char.quote(root .. "/" .. cfg.classes_dir) .. "/; break; fi; done"
    parts[#parts + 1] = "&&"
    parts[#parts + 1] = "find target -maxdepth 3 -name '*.jar' -exec cp -a {} "
        .. beez.char.quote(root .. "/" .. cfg.bin_dir) .. "/ \\; 2>/dev/null || true"

    return table.concat(parts, " ")
end

function M.verify_artifacts(cfg, root)
    return "test -d " .. beez.char.quote(root .. "/" .. cfg.classes_dir)
        .. " && ( test -d " .. beez.char.quote(root .. "/" .. cfg.bin_dir)
        .. " && ls " .. beez.char.quote(root .. "/" .. cfg.bin_dir) .. "/*.jar >/dev/null 2>&1 )"
        .. " || test -d " .. beez.char.quote(root .. "/" .. cfg.classes_dir)
end

function M.test(cfg, root)
    local ok_file = root .. "/" .. cfg.reports_dir .. "/test/chisel-" .. cfg.profile_name .. ".ok"
    local parts = {
        "mkdir -p " .. beez.char.quote(root .. "/" .. cfg.reports_dir .. "/test"),
        "&&",
        project_cd(cfg, root),
        "&&",
    }

    if cfg.has_tests then
        parts[#parts + 1] = cfg.sbt_binary
        parts[#parts + 1] = "-batch"
        parts[#parts + 1] = "-Dsbt.supershell=false"
        parts[#parts + 1] = cfg.sbt_test_task
        if cfg.test_args ~= nil and cfg.test_args ~= "" then
            parts[#parts + 1] = cfg.test_args
        end
        parts[#parts + 1] = "&&"
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    else
        parts[#parts + 1] = "touch " .. beez.char.quote(ok_file)
    end

    return table.concat(parts, " ")
end



return M
