local M = {}

local function sort_shallow_first(paths)
    table.sort(paths, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)
end

local function is_likely_binary(path)
    if path:match("/%.git/") then
        return false
    end
    if path:match("/build/") or path:match("/report/") then
        return false
    end
    if path:match("%.lua$") or path:match("%.md$") or path:match("%.txt$") then
        return false
    end
    if path:match("%.json$") or path:match("%.xml$") or path:match("%.yaml$") then
        return false
    end
    if path:match("%.yml$") or path:match("%.toml$") or path:match("%.py$") then
        return false
    end
    if path:match("%.c$") or path:match("%.cpp$") or path:match("%.h$") then
        return false
    end
    if path:match("%.spec$") or path:match("%.in$") then
        return false
    end
    if path:match("%.sh$") or path:match("Makefile$") then
        return false
    end
    if path:match("%.so$") or path:match("%.so%.") then
        return true
    end
    if path:match("%.dll$") or path:match("%.dylib$") then
        return true
    end
    if path:match("%.exe$") or path:match("%.bin$") or path:match("%.elf$") then
        return true
    end
    if path:match("%.o$") or path:match("%.a$") then
        return true
    end
    if path:match("/bin/") or path:match("/sbin/") then
        return true
    end
    return not path:match("%.")
end

function M.resolve_entry_source(ctx, root, cfg_entry)
    if cfg_entry ~= nil and cfg_entry ~= "" then
        return cfg_entry
    end

    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*",
        prefix .. "/*",
    })

    sort_shallow_first(files)

    for _, file in ipairs(files) do
        if is_likely_binary(file) then
            return file
        end
    end

    if #files > 0 then
        return files[1]
    end

    return nil
end

function M.resolve_all_binaries(ctx, root)
    local prefix = "."
    if root ~= "." and root ~= "" then
        prefix = root
    end

    local files = ctx.glob({
        prefix .. "/**/*",
        prefix .. "/*",
    })

    sort_shallow_first(files)

    local binaries = {}
    for _, file in ipairs(files) do
        if is_likely_binary(file) then
            binaries[#binaries + 1] = file
        end
    end

    return binaries
end

function M.resolve(ctx, cfg)
    local root = cfg.project_root or "."
    local entry_source = M.resolve_entry_source(ctx, root, cfg.entry_source)
    local all_files = ctx.glob({ "**/*" })

    if entry_source == nil and #all_files == 0 then
        error("radare2 plugin: no files found — add binaries or set entry_source in configure()")
    end

    local bin_dir = cfg.bin_dir or "build/radare2/bin"
    local output_name = cfg.output_name or "analyze.ok"
    local primary_output = bin_dir .. "/" .. output_name
    local binaries = M.resolve_all_binaries(ctx, root)

    return {
        project_root = root,
        entry_source = entry_source,
        bin_dir = bin_dir,
        output_name = output_name,
        primary_output = primary_output,
        binaries = binaries,
    }
end

return M
