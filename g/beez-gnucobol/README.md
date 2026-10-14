# gnucobol

Official GnuCOBOL compiler plugin — `cobc` with auto-detected targets.

Plugin ID: **`coditary/gnucobol`**

## Install

```lua
reqpack { beez = { { name = "coditary/gnucobol", version = "1.0.0", source = "github:Coditary/beez-gnucobol" } } }
```

## Usage

```lua
configure({ { "coditary/gnucobol", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[gnucobol]
beez -s coditary/gnucobol:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `cobc` | Creates `build/gnucobol/.gnucobol-setup` |
| compile | `cobc` | Output under `build/gnucobol/` |
| bundle | verify artifacts | Checks compile outputs |
| test | verify build output | Writes `report/test/gnucobol-*.ok` |

## Detection

- Markers: `**/*.cob`, `**/*.cbl`
- Compile targets: all non-test source files

## License

Apache License 2.0.
