# obnc

Official Oberon compiler plugin — compile .obn sources with obnc, auto-detected **/*.obn.

Plugin ID: **`coditary/obnc`**

## Install

```lua
reqpack { beez = { { name = "coditary/obnc", version = "1.0.0", source = "github:Coditary/beez-obnc" } } }
```

## Usage

```lua
configure({ { "coditary/obnc", {} } })
workflows({ build = "coditary/obnc:build" })
```

```bash
beez build
beez -p compile[obnc]
beez -s obnc:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `obnc` | Verify `obnc` toolchain |
| compile | `obnc` | Compile detected sources |
| bundle | `obnc` | Verify build artifacts under `build/obnc/bin/` |
| test | `obnc` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.obn`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `obnc` (override with `OBNC` env or `obnc_binary` config)

## License

Apache License 2.0.
