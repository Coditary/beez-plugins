# golo

Official Golo JVM language plugin — `golo compile` with auto-detected `.golo` targets.

Plugin ID: **`coditary/golo`**

## Install

```lua
reqpack { beez = { { name = "coditary/golo", version = "1.0.0", source = "github:Coditary/beez-golo" } } }
```

## Usage

```lua
configure({ { "coditary/golo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[golo]
beez -s golo:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `golo` | Verify compiler and prepare `build/golo/` |
| compile | `golo compile` | Compiles `.golo` to jar or class directory |
| bundle | verify artifacts | Checks outputs under `build/golo/` |
| test | `golo run` / `golo golo` | Writes `report/test/golo-*.ok` |

## Detection

- Markers: `**/*.golo`
- Scope: `golo`
- Binary: `golo` (override with `GOLO` env or `golo_binary` config)

## License

Apache License 2.0.
