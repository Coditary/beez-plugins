local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    return path:match("([^/]+)$") or path
end

function M.find_cargo_toml(ctx)
    local manifests = ctx.glob({ "Cargo.toml", "**/Cargo.toml" })
    if #manifests == 0 then
        return nil
    end

    table.sort(manifests, function(a, b)
        local depth_a = select(2, a:gsub("/", ""))
        local depth_b = select(2, b:gsub("/", ""))
        if depth_a == depth_b then
            return a < b
        end
        return depth_a < depth_b
    end)

    return manifests[1]
end

function M.resolve_crate_targets(ctx, workspace_root, package_name)
    local prefix = (workspace_root ~= "." and workspace_root ~= "") and (workspace_root .. "/") or ""

    local main_rs = ctx.glob({ prefix .. "src/main.rs" })
    local bin_sources = ctx.glob({ prefix .. "src/bin/*.rs" })
    local targets, seen = {}, {}

    if #main_rs > 0 then
        local source = main_rs[1]
        local name = package_name or "app"
        seen[name] = true
        targets[#targets + 1] = { name = name, source = source }
    end

    for _, bin_path in ipairs(bin_sources) do
        local name = bin_path:match("/src/bin/([^/]+)%.rs$") or "app"
        if not seen[name] then
            seen[name] = true
            targets[#targets + 1] = { name = name, source = bin_path }
        end
    end

    if #targets == 0 then
        local fallback = prefix .. "src/main.rs"
        if #ctx.glob({ fallback }) > 0 then
            targets[#targets + 1] = { name = package_name or "app", source = fallback }
        else
            error("mrustc plugin: Cargo.toml found but no src/main.rs or src/bin/*.rs targets")
        end
    end

    return targets
end

function M.resolve(ctx, cfg)
    local cargo_toml = cfg.cargo_toml or M.find_cargo_toml(ctx)
    if cargo_toml == nil then
        error("mrustc plugin: no Cargo.toml found")
    end

    local workspace_root = cfg.workspace_root or dirname(cargo_toml)
    local package_name = cfg.package_name or basename(workspace_root)
    if package_name == "." then
        package_name = "app"
    end

    local targets = cfg.targets or M.resolve_crate_targets(ctx, workspace_root, package_name)
    local bin_dir = cfg.bin_dir or "build/mrustc/bin"

    for _, target in ipairs(targets) do
        target.output = target.output or (bin_dir .. "/" .. target.name)
    end

    return {
        cargo_toml = cargo_toml,
        workspace_root = workspace_root,
        package_name = package_name,
        targets = targets,
        bin_dir = bin_dir,
        primary_output = targets[1].output,
        primary_source = targets[1].source,
    }
end

return M
