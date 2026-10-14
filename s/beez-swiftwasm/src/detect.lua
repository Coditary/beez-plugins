local M = {}

local function dirname(path)
    return path:match("^(.*)/[^/]+$") or "."
end

local function basename(path)
    local name = path:match("([^/]+)$")
    return name or path
end

function M.find_package_manifest(ctx)
    local wasm_manifests = ctx.glob({
        "Package@swift-5.9-wasm.swift",
        "**/Package@swift-5.9-wasm.swift",
    })
    if #wasm_manifests > 0 then
        table.sort(wasm_manifests)
        return wasm_manifests[1]
    end

    local manifests = ctx.glob({ "Package.swift", "**/Package.swift" })
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

function M.package_root(package_manifest_path)
    return dirname(package_manifest_path)
end

function M.resolve_executables(ctx, cfg)
    local root = cfg.package_root
    local prefix = root
    if root ~= "." and root ~= "" then
        prefix = root .. "/"
    else
        prefix = ""
    end

    local mains = ctx.glob({
        prefix .. "Sources/*/main.swift",
        prefix .. "Sources/**/main.swift",
    })

    local names = {}
    local seen = {}

    for _, main_path in ipairs(mains) do
        local parent = dirname(main_path)
        local name = basename(parent)
        if name == "Sources" then
            name = cfg.package_name or "app"
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
    local package_manifest = cfg.package_manifest or M.find_package_manifest(ctx)
    if package_manifest == nil then
        error("swiftwasm plugin: no Package.swift or Package@swift-5.9-wasm.swift found — add a Swift package or set package_manifest in configure()")
    end

    local package_root = cfg.package_root or M.package_root(package_manifest)
    local bin_dir = cfg.bin_dir or "build/swiftwasm/wasm"
    local executable_names = cfg.executable_names

    if executable_names == nil then
        executable_names = M.resolve_executables(ctx, {
            package_root = package_root,
            package_name = cfg.package_name,
        })
    end

    local outputs = {}
    for _, name in ipairs(executable_names) do
        local output = bin_dir .. "/" .. name
        if not output:match("%.wasm$") then
            output = output .. ".wasm"
        end
        outputs[#outputs + 1] = output
    end

    return {
        package_manifest = package_manifest,
        package_root = package_root,
        executable_names = executable_names,
        bin_dir = bin_dir,
        primary_output = outputs[1],
    }
end

return M
