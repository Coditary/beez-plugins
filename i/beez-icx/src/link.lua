local command = require("src.command")

local M = {}

local function sorted_links(links)
    local sorted = {}
    for _, link_entry in ipairs(links) do
        sorted[#sorted + 1] = link_entry
    end

    table.sort(sorted, function(left, right)
        return left.target < right.target
    end)

    return sorted
end

local function resolve_link_outputs(profile, config)
    local outputs = profile.link_outputs
    if type(outputs) == "function" then
        return outputs(config.build_tree)
    end

    return outputs or {}
end

local function matches_output(link_entry, patterns, root, build_tree)
    if #patterns == 0 then
        return true
    end

    local output = link_entry.output or ""
    for _, pattern in ipairs(patterns) do
        if pattern:find("/%*%*", 1, true) then
            local rel_prefix = build_tree .. "/" .. pattern:gsub("/%*%*", "/")
            local abs_prefix = root .. "/" .. rel_prefix
            if output:sub(1, #abs_prefix) == abs_prefix then
                return true
            end
        else
            local abs = root .. "/" .. pattern
            if output == abs then
                return true
            end
        end
    end

    return false
end

local function filter_links(links, profile, config, root)
    local patterns = resolve_link_outputs(profile, config)
    local filtered = {}

    for _, link_entry in ipairs(links) do
        if matches_output(link_entry, patterns, root, config.build_tree) then
            filtered[#filtered + 1] = link_entry
        end
    end

    return filtered
end

function M.run(ctx, config, profile, index, root)
    local links = sorted_links(filter_links(index.links or {}, profile, config, root))
    if #links == 0 then
        print(config.log_prefix_link .. " no link targets found in index")
        return 1
    end

    for _, link_entry in ipairs(links) do
        print(config.log_prefix_link .. " linking: " .. link_entry.target)
        local code = beez.shell.run(ctx, config.log_prefix_link, command.link(config, link_entry))
        if code ~= 0 then
            return code
        end
    end

    if profile.post_link ~= nil then
        local post_link_cmd = profile.post_link(config.build_tree)
        if post_link_cmd ~= nil and post_link_cmd ~= "" then
            print(config.log_prefix_link .. " post-link: " .. post_link_cmd)
            local post_code = beez.shell.run(ctx, config.log_prefix_link, post_link_cmd)
            if post_code ~= 0 then
                return post_code
            end
        end
    end

    return 0
end

return M
