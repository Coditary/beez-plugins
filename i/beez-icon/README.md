# icon

Official Icon compiler plugin — `iconx -c` compile and `iconx` run with auto-detected `*.icn` targets.

Plugin ID: **`coditary/icon`**

## Install

```lua
reqpack { beez = { { name = "coditary/icon", version = "1.0.0", source = "github:Coditary/beez-icon" } } }
```

## Usage

```lua
configure({ { "coditary/icon", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[icon]
beez -s coditary/icon:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `iconx` | Creates `build/icon/.icon-setup` |
| compile | `iconx -c` | Compiles all non-test `.icn` sources |
| bundle | verify compile stamp | Checks `build/icon/.icon-compile-*` |
| test | run primary program | Executes `main.icn` or first entry |

## Detection

- Markers: `**/*.icn`
- Entry points: `main.icn`, or first non-test source
- Binary: `iconx` (override with `ICONX` env or `iconx_binary` config)

## License

Apache License 2.0.
