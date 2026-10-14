# luau

Official Luau compiler and typechecker (Roblox) — `luau --binary` and `luau-analyze` with auto-detected targets.

Plugin ID: **`coditary/luau`**

## Install

```lua
reqpack { beez = { { name = "coditary/luau", version = "1.0.0", source = "github:Coditary/beez-luau" } } }
```

## Usage

```lua
configure({ { "coditary/luau", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[luau]
beez -s coditary/luau:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `luau`/`luau-analyze` | Creates `build/luau/.luau-setup` |
| compile | `luau --binary` | Output under `build/luau/` |
| bundle | verify bytecode | Checks `build/luau/*.luauc` |
| test | `luau-analyze` | Typechecks all project sources |

## Detection

- Markers: `**/*.luau`, `**/*.lua`, `default.project.json`
- Entry points: `src/init.luau`, `init.luau`, `main.luau`, `src/main.luau`, or first non-test source

## Scope

Release builds use scope **`luau`**, matching Roblox/Luau pipeline conventions.

## License

Apache License 2.0.
