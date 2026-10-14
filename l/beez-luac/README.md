# luac

Official Lua bytecode compiler — `luac -o` with auto-detected targets.

Plugin ID: **`coditary/luac`**

## Install

```lua
reqpack { beez = { { name = "coditary/luac", version = "1.0.0", source = "github:Coditary/beez-luac" } } }
```

## Usage

```lua
configure({ { "coditary/luac", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[luac]
beez -s coditary/luac:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `luac`/`lua` | Creates `build/luac/.luac-setup` |
| compile | `luac -o` | Output under `build/luac/` |
| bundle | verify bytecode | Checks `build/luac/*.luac` |
| test | `lua` run | Executes compiled bytecode |

## Detection

- Markers: `**/*.lua`
- Entry points: `main.lua`, `src/main.lua`, or first non-test `*.lua`

## License

Apache License 2.0.
