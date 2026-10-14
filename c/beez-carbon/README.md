# carbon

Official Carbon compiler plugin — `carbon` with auto-detected targets.

Plugin ID: **`coditary/carbon`**

## Install

```lua
reqpack { beez = { { name = "coditary/carbon", version = "1.0.0", source = "github:Coditary/beez-carbon" } } }
```

## Usage

```lua
configure({ { "coditary/carbon", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[carbon]
beez -s coditary/carbon:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `carbon` | Creates `build/carbon/.carbon-setup` |
| compile | `carbon` | Output under `build/carbon/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/carbon-*.ok` |

## Detection

- Markers: `**/*.carbon`
- Compile targets: all non-test source files

## License

Apache License 2.0.
