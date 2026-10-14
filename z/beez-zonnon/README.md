# zonnon

Official zonnon compiler plugin — Zonnon .NET — ncc compile with auto-detected **/*.zonnon targets.

Plugin ID: **`coditary/zonnon`**

## Install

```lua
reqpack { beez = { { name = "coditary/zonnon", version = "1.0.0", source = "github:Coditary/beez-zonnon" } } }
```

## Usage

```lua
configure({ { "coditary/zonnon", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[zonnon]
beez -s zonnon:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `ncc` | Prepare `build/zonnon/` |
| compile | `ncc` on sources | Writes artifacts under `build/zonnon/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/zonnon-*.ok` |

## Detection

- Markers: `**/*.zonnon`
- Compile Zonnon sources to .NET with `ncc`.
- Binary: `ncc` (override with `ZONNON` env or `zonnon_binary` config)

## License

Apache License 2.0.
