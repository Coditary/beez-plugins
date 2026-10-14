# topspeed

Official Clarion/Topspeed plugin — topspeed compile with auto-detected `.clw` sources.

Plugin ID: **`coditary/topspeed`**

## Install

```lua
reqpack { beez = { { name = "coditary/topspeed", version = "1.0.0", source = "github:Coditary/beez-topspeed" } } }
```

## Usage

```lua
configure({ { "coditary/topspeed", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[topspeed]
beez -s topspeed:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `topspeed` | Writes setup stamp under `build/topspeed/` |
| compile | `topspeed` on all sources | Writes compile stamp under `build/topspeed/` |
| bundle | verify compile stamp | Checks `build/topspeed/.topspeed-compile-*` |
| test | placeholder test runner | Writes `report/test/topspeed-*.ok` |

## Detection

- Markers: `**/*.clw`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `topspeed` (override with `TOPSPEED` env or `topspeed_binary` config)

## License

Apache License 2.0.
