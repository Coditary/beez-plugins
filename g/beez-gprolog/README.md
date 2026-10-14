# gprolog

Official GNU Prolog compiler plugin — compile .pl sources with gplc, auto-detected **/*.pl.

Plugin ID: **`coditary/gprolog`**

## Install

```lua
reqpack { beez = { { name = "coditary/gprolog", version = "1.0.0", source = "github:Coditary/beez-gprolog" } } }
```

## Usage

```lua
configure({ { "coditary/gprolog", {} } })
workflows({ build = "coditary/gprolog:build" })
```

```bash
beez build
beez -p compile[gprolog]
beez -s gprolog:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `gprolog` | Verify `gplc` toolchain |
| compile | `gprolog` | Compile detected sources |
| bundle | `gprolog` | Verify build artifacts under `build/gprolog/bin/` |
| test | `gprolog` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.pl`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `gplc` (override with `GPLC` env or `gplc_binary` config)

## License

Apache License 2.0.
