# idris2

Official Idris 2 compiler plugin — build packages with idris2, auto-detected **/*.idr and *.ipkg.

Plugin ID: **`coditary/idris2`**

## Install

```lua
reqpack { beez = { { name = "coditary/idris2", version = "1.0.0", source = "github:Coditary/beez-idris2" } } }
```

## Usage

```lua
configure({ { "coditary/idris2", {} } })
workflows({ build = "coditary/idris2:build" })
```

```bash
beez build
beez -p compile[idris2]
beez -s idris2:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `idris2` | Verify `idris2` toolchain |
| compile | `idris2` | Compile detected sources |
| bundle | `idris2` | Verify build artifacts under `build/idris2/bin/` |
| test | `idris2` | Run primary output or write test stamp |

## Detection

- Markers: `*.ipkg`, `**/*.ipkg`, `**/*.idr`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `idris2` (override with `IDRIS2` env or `idris2_binary` config)

## License

Apache License 2.0.
