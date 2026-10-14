# moonscript

Official MoonScript compiler — `moonc` to Lua with auto-detected targets.

Plugin ID: **`coditary/moonscript`**

## Install

```lua
reqpack { beez = { { name = "coditary/moonscript", version = "1.0.0", source = "github:Coditary/beez-moonscript" } } }
```

## Usage

```lua
configure({ { "coditary/moonscript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[moonscript]
beez -s coditary/moonscript:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `moonc`/`lua` | Creates `build/moonscript/.moonscript-setup` |
| compile | `moonc -t` | Output under `build/moonscript/` |
| bundle | verify Lua | Checks `build/moonscript/*.lua` |
| test | `lua` run | Executes compiled Lua |

## Detection

- Markers: `**/*.moon`
- Entry points: `main.moon`, `src/main.moon`, or first non-test `*.moon`

## License

Apache License 2.0.
