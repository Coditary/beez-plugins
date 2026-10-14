local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
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

function M.workspace_root(cargo_toml_path)
    return dirname(cargo_toml_path)
end

function M.resolve_binaries(ctx, cfg)
    local root = cfg.workspace_root
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local bins = ctx.glob({
        prefix .. "src/main.rs",
        prefix .. "src/bin/*.rs",
    })

    local names = {}
    local seen = {}

    for _, bin_path in ipairs(bins) do
        local name
        if bin_path:match("/src/main%.rs$") then
            name = cfg.package_name or "app"
        else
            name = bin_path:match("/src/bin/([^/]+)%.rs$") or "app"
        end

        if not seen[name] then
            seen[name] = true
            names[#names + 1] = name
        end
    end

    if #names == 0 then
        names[#names + 1] = cfg.package_name or "app"
    end

    return names
end

function M.resolve(ctx, cfg)
    local cargo_toml = cfg.cargo_toml or M.find_cargo_toml(ctx)
    if cargo_toml == nil then
        error("rustc-gcc plugin: no Cargo.toml found — add a Rust crate or set cargo_toml in configure()")
    end

    local workspace_root = cfg.workspace_root or M.workspace_root(cargo_toml)
    local bin_dir = cfg.bin_dir or "target/rustc-gcc/release"
    local binary_names = cfg.binary_names

    if binary_names == nil then
        binary_names = M.resolve_binaries(ctx, {
            workspace_root = workspace_root,
            package_name = cfg.package_name,
        })
    end

    local outputs = {}
    for _, name in ipairs(binary_names) do
        outputs[#outputs + 1] = bin_dir .. "/" .. name
    end

    return {
        cargo_toml = cargo_toml,
        workspace_root = workspace_root,
        binary_names = binary_names,
        bin_dir = bin_dir,
        primary_output = outputs[1],
    }
end

return M
