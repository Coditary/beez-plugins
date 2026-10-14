# idris

Official Idris 1 compiler plugin — type-check and build with idris, auto-detected **/*.idr.

Plugin ID: **`coditary/idris`**

## Install

```lua
reqpack { beez = { { name = "coditary/idris", version = "1.0.0", source = "github:Coditary/beez-idris" } } }
```

## Usage

```lua
configure({ { "coditary/idris", {} } })
workflows({ build = "coditary/idris:build" })
```

```bash
beez build
beez -p compile[idris]
beez -s idris:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `idris` | Verify `idris` toolchain |
| compile | `idris` | Compile detected sources |
| bundle | `idris` | Verify build artifacts under `build/idris/bin/` |
| test | `idris` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.idr`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `idris` (override with `IDRIS` env or `idris_binary` config)

## License

Apache License 2.0.
