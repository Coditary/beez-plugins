# red

Official red compiler plugin — Red language — red -c compile with auto-detected **/*.red targets.

Plugin ID: **`coditary/red`**

## Install

```lua
reqpack { beez = { { name = "coditary/red", version = "1.0.0", source = "github:Coditary/beez-red" } } }
```

## Usage

```lua
configure({ { "coditary/red", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[red]
beez -s red:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `red` | Prepare `build/red/` |
| compile | `red` on sources | Writes artifacts under `build/red/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/red-*.ok` |

## Detection

- Markers: `**/*.red`
- Compile with `red -c -o` on all `**/*.red` sources.
- Binary: `red` (override with `RED` env or `red_binary` config)

## License

Apache License 2.0.
