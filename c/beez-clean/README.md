# clean

Official Clean compiler plugin — `clm` with auto-detected targets.

Plugin ID: **`coditary/clean`**

## Install

```lua
reqpack { beez = { { name = "coditary/clean", version = "1.0.0", source = "github:Coditary/beez-clean" } } }
```

## Usage

```lua
configure({ { "coditary/clean", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[clean]
beez -s coditary/clean:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `clm` | Creates `build/clean/.clean-setup` |
| compile | `clm` | Output under `build/clean/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/clean-*.ok` |

## Detection

- Markers: `**/*.icl`
- Compile targets: all non-test source files

## License

Apache License 2.0.
