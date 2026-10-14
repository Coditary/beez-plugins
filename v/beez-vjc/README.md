# vjc

Official Visual J# compiler plugin — compile J# sources with vjc, auto-detected **/*.java.

Plugin ID: **`coditary/vjc`**

## Install

```lua
reqpack { beez = { { name = "coditary/vjc", version = "1.0.0", source = "github:Coditary/beez-vjc" } } }
```

## Usage

```lua
configure({ { "coditary/vjc", {} } })
workflows({ build = "coditary/vjc:build" })
```

```bash
beez build
beez -p compile[vjc]
beez -s vjc:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `vjc` | Verify `vjc` toolchain |
| compile | `vjc` | Compile detected sources |
| bundle | `vjc` | Verify build artifacts under `build/vjc/bin/` |
| test | `vjc` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.java`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `vjc` (override with `VJC` env or `vjc_binary` config)

## License

Apache License 2.0.
