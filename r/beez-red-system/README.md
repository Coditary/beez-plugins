# red-system

Official red-system compiler plugin — Red/System native — red -c -s compile with auto-detected **/*.reds targets.

Plugin ID: **`coditary/red-system`**

## Install

```lua
reqpack { beez = { { name = "coditary/red-system", version = "1.0.0", source = "github:Coditary/beez-red-system" } } }
```

## Usage

```lua
configure({ { "coditary/red-system", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[red-system]
beez -s red-system:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `red` | Prepare `build/red-system/` |
| compile | `red` on sources | Writes artifacts under `build/red-system/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/red-system-*.ok` |

## Detection

- Markers: `**/*.reds`
- Compile Red/System sources with `red -c -s -o`.
- Binary: `red` (override with `RED` env or `red_binary` config)

## License

Apache License 2.0.
