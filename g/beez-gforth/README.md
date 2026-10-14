# gforth

Official Gforth compiler plugin — Gforth with auto-detected source targets.

Plugin ID: **`coditary/gforth`**

## Install

```lua
reqpack { beez = { { name = "coditary/gforth", version = "1.0.0", source = "github:Coditary/beez-gforth" } } }
```

## Usage

```lua
configure({ { "coditary/gforth", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[gforth]
beez -s gforth:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `gforth` | Verify compiler and prepare `build/gforth/` |
| compile | `gforth` | Check via `gforth -e bye <source>`. |
| bundle | verify artifacts | Checks outputs under `build/gforth/` |
| test | `prove -l t/` | Writes `report/test/gforth-*.ok` |

## Detection

- Markers: `**/*.fs`, `**/*.fth`
- Scope: `gforth`
- Binary: `gforth` (override with `GFORTH` env or `gforth_binary` config)

## License

Apache License 2.0.
