# pli

Official PL/I compiler plugin — compile .pli sources, auto-detected **/*.pli.

Plugin ID: **`coditary/pli`**

## Install

```lua
reqpack { beez = { { name = "coditary/pli", version = "1.0.0", source = "github:Coditary/beez-pli" } } }
```

## Usage

```lua
configure({ { "coditary/pli", {} } })
workflows({ build = "coditary/pli:build" })
```

```bash
beez build
beez -p compile[pli]
beez -s pli:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `pli` | Verify `pli` toolchain |
| compile | `pli` | Compile detected sources |
| bundle | `pli` | Verify build artifacts under `build/pli/bin/` |
| test | `pli` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.pli`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `pli` (override with `PLI` env or `pli_binary` config)

## License

Apache License 2.0.
