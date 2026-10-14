# cm3

Official Critical Mass Modula-3 compiler plugin — cm3 build with auto-detected **/*.i3 and **/*.m3.

Plugin ID: **`coditary/cm3`**

## Install

```lua
reqpack { beez = { { name = "coditary/cm3", version = "1.0.0", source = "github:Coditary/beez-cm3" } } }
```

## Usage

```lua
configure({ { "coditary/cm3", {} } })
workflows({ build = "coditary/cm3:build" })
```

```bash
beez build
beez -p compile[cm3]
beez -s cm3:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `cm3` | Verify `cm3` toolchain |
| compile | `cm3` | Compile detected sources |
| bundle | `cm3` | Verify build artifacts under `build/cm3/bin/` |
| test | `cm3` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.i3`, `**/*.m3`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `cm3` (override with `CM3` env or `cm3_binary` config)

## License

Apache License 2.0.
