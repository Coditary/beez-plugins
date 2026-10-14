# harbour

Official Harbour compiler plugin — `harbour` with auto-detected targets.

Plugin ID: **`coditary/harbour`**

## Install

```lua
reqpack { beez = { { name = "coditary/harbour", version = "1.0.0", source = "github:Coditary/beez-harbour" } } }
```

## Usage

```lua
configure({ { "coditary/harbour", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[harbour]
beez -s coditary/harbour:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `harbour` | Creates `build/harbour/.harbour-setup` |
| compile | `harbour` | Output under `build/harbour/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/harbour-*.ok` |

## Detection

- Markers: `**/*.prg`
- Compile targets: all non-test source files

## License

Apache License 2.0.
