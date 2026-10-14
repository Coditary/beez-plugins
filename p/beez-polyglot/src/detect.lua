local defaults = require("src.defaults")

local M = {}

function M.has_any(ctx, patterns)
    local files = ctx.glob(patterns)
    return #files > 0, files
end

function M.detect_language(ctx, lang_id, lang_def)
    local found, marker_files = M.has_any(ctx, lang_def.markers)
    if not found then
        return nil
    end

    local source_files = ctx.glob(lang_def.source_globs)

    return {
        id = lang_id,
        name = lang_def.name,
        plugin = lang_def.plugin,
        companion_plugins = lang_def.companion_plugins,
        markers = marker_files,
        source_count = #source_files,
        source_sample = source_files[1],
        setup_scope = lang_def.setup_scope,
        compile_scope = lang_def.compile_scope,
        bundle_scope = lang_def.bundle_scope,
        test_scope = lang_def.test_scope,
    }
end

function M.detect_all(ctx)
    local detected = {}

    for _, lang_id in ipairs(defaults.language_order) do
        local lang_def = defaults.languages[lang_id]
        local result = M.detect_language(ctx, lang_id, lang_def)
        if result ~= nil then
            detected[#detected + 1] = result
        end
    end

    return detected
end

function M.required_plugins(detected)
    local plugins = {}
    local seen = {}

    for _, lang in ipairs(detected) do
        if not seen[lang.plugin] then
            seen[lang.plugin] = true
            plugins[#plugins + 1] = lang.plugin
        end

        for _, companion in ipairs(lang.companion_plugins) do
            if not seen[companion] then
                seen[companion] = true
                plugins[#plugins + 1] = companion
            end
        end
    end

    plugins[#plugins + 1] = "coditary/pipeline"
    plugins[#plugins + 1] = "coditary/polyglot"

    return plugins
end

function M.format_report(detected)
    if #detected == 0 then
        return "No supported languages detected.\n" ..
            "Add go.mod, Cargo.toml, or CMakeLists.txt/conanfile.py to your project."
    end

    local lines = { "Detected languages:" }
    for _, lang in ipairs(detected) do
        lines[#lines + 1] = string.format(
            "  - %s (%s): %d source files, plugin %s",
            lang.name,
            lang.id,
            lang.source_count,
            lang.plugin
        )
    end

    lines[#lines + 1] = ""
    lines[#lines + 1] = "Recommended plugins:"
    for _, plugin in ipairs(M.required_plugins(detected)) do
        lines[#lines + 1] = "  - " .. plugin
    end

    return table.concat(lines, "\n")
end

return M
