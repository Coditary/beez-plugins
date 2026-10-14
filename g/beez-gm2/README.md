# gm2

Official GNU Modula-2 compiler plugin — compile .mod sources with gm2, auto-detected **/*.mod.

Plugin ID: **`coditary/gm2`**

## Install

```lua
reqpack { beez = { { name = "coditary/gm2", version = "1.0.0", source = "github:Coditary/beez-gm2" } } }
```

## Usage

```lua
configure({ { "coditary/gm2", {} } })
workflows({ build = "coditary/gm2:build" })
```

```bash
beez build
beez -p compile[gm2]
beez -s gm2:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `gm2` | Verify `gm2` toolchain |
| compile | `gm2` | Compile detected sources |
| bundle | `gm2` | Verify build artifacts under `build/gm2/bin/` |
| test | `gm2` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.mod`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `gm2` (override with `GM2` env or `gm2_binary` config)

## License

Apache License 2.0.
