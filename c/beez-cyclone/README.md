# cyclone

Official Cyclone plugin — cyclone compile with auto-detected `.cyc` sources.

Plugin ID: **`coditary/cyclone`**

## Install

```lua
reqpack { beez = { { name = "coditary/cyclone", version = "1.0.0", source = "github:Coditary/beez-cyclone" } } }
```

## Usage

```lua
configure({ { "coditary/cyclone", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[cyclone]
beez -s cyclone:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `cyclone` | Writes setup stamp under `build/cyclone/` |
| compile | `cyclone` on all sources | Writes compile stamp under `build/cyclone/` |
| bundle | verify compile stamp | Checks `build/cyclone/.cyclone-compile-*` |
| test | placeholder test runner | Writes `report/test/cyclone-*.ok` |

## Detection

- Markers: `**/*.cyc`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `cyclone` (override with `CYCLONE` env or `cyclone_binary` config)

## License

Apache License 2.0.
