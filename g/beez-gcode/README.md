# gcode

Official G-code CNC plugin — CAMotics validation with auto-detected `.gcode` and `.nc` targets.

Plugin ID: **`coditary/gcode`**

## Install

```lua
reqpack { beez = { { name = "coditary/gcode", version = "1.0.0", source = "github:Coditary/beez-gcode" } } }
```

## Usage

```lua
configure({ { "coditary/gcode", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[gcode]
beez -s gcode:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `camotics` | Verify toolchain and prepare `build/gcode/` |
| compile | `camotics` | Stage G-code and simulate toolpaths |
| bundle | verify artifacts | Checks outputs under `build/gcode/` |
| test | `camotics` | Writes `report/test/gcode-*.ok` |

## Detection

- Markers: `**/*.gcode`, `**/*.nc`
- Scope: `gcode`
- Binary: `camotics` (override with `CAMOTICS` env or `gcode_binary` config)

## License

Apache License 2.0.
