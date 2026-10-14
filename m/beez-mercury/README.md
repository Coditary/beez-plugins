# mercury

Official Mercury compiler plugin — mmc to C with auto-detected **/*.m and Mercury.options.

Plugin ID: **`coditary/mercury`**

## Install

```lua
reqpack { beez = { { name = "coditary/mercury", version = "1.0.0", source = "github:Coditary/beez-mercury" } } }
```

## Usage

```lua
configure({ { "coditary/mercury", {} } })
workflows({ build = "coditary/mercury:build" })
```

```bash
beez build
beez -p compile[mercury]
beez -s mercury:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `mercury` | Verify `mmc` toolchain |
| compile | `mercury` | Compile detected sources |
| bundle | `mercury` | Verify build artifacts under `build/mercury/bin/` |
| test | `mercury` | Run primary output or write test stamp |

## Detection

- Markers: `Mercury.options`, `**/Mercury.options`, `**/*.m`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `mmc` (override with `MMC` env or `mmc_binary` config)

## License

Apache License 2.0.
