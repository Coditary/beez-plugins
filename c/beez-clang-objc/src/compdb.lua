local command = require("src.command")

local M = {}

local function compdb_path(config, root)
    local in_tree = config.build_tree_abs .. "/compile_commands.json"
    if beez.fs.exists(in_tree) then
        return in_tree
    end

    local at_root = root .. "/compile_commands.json"
    if beez.fs.exists(at_root) then
        return at_root
    end

    return nil
end

local function load_index_file(config)
    local index_path = config.index_lua_abs
    local chunk, load_error = loadfile(index_path)
    if chunk == nil then
        print(config.log_prefix_compile .. " failed to load index: " .. tostring(load_error))
        return nil, 1
    end

    local index = chunk()
    if index == nil or index.entries == nil then
        print(config.log_prefix_compile .. " invalid clang-objc index at " .. index_path)
        return nil, 1
    end

    return index, 0
end

function M.generate_index(config, root, ctx)
    local log_prefix = config.log_prefix_setup

    local code = beez.shell.run(ctx, log_prefix, command.ensure_compdb_symlink(config, root))
    if code ~= 0 then
        return code
    end

    if compdb_path(config, root) == nil then
        print(log_prefix .. " compile_commands.json not found")
        print(log_prefix .. " Place it in " .. config.build_tree .. "/ or project root.")
        return 2
    end

    code = beez.shell.run(ctx, log_prefix, command.index(config, root))
    if code ~= 0 then
        return code
    end

    local _, load_code = load_index_file(config)
    return load_code
end

function M.load_index(config, root, ctx)
    local log_prefix = config.log_prefix_compile
    local index_path = config.index_lua_abs

    if not beez.fs.exists(index_path) then
        print(log_prefix .. " index not found: " .. index_path)
        print(log_prefix .. " Run setup first (e.g. beez -s clang-objc:setup).")
        return nil, 2
    end

    return load_index_file(config)
end

return M
