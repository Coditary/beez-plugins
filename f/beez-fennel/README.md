# fennel

Official Fennel compiler — `fennel --compile` with auto-detected targets.

Plugin ID: **`coditary/fennel`**

## Install

```lua
reqpack { beez = { { name = "coditary/fennel", version = "1.0.0", source = "github:Coditary/beez-fennel" } } }
```

## Usage

```lua
configure({ { "coditary/fennel", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[fennel]
beez -s coditary/fennel:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `fennel`/`lua` | Creates `build/fennel/.fennel-setup` |
| compile | `fennel --compile` | Output under `build/fennel/` |
| bundle | verify Lua output | Checks `build/fennel/*.lua` |
| test | `lua` run | Executes compiled Lua |

## Detection

- Markers: `**/*.fnl`
- Entry points: `main.fnl`, `src/main.fnl`, or first non-test `*.fnl`

## License

Apache License 2.0.
