# aldor

Official Aldor CAS plugin — `aldor -laldor` compile with auto-detected `.ad` targets.

Plugin ID: **`coditary/aldor`**

## Install

```lua
reqpack { beez = { { name = "coditary/aldor", version = "1.0.0", source = "github:Coditary/beez-aldor" } } }
```

## Usage

```lua
configure({ { "coditary/aldor", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[aldor]
beez -s aldor:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `aldor` | Writes setup stamp under `build/aldor/` |
| compile | `aldor -laldor` on all sources | Writes compile stamp under `build/aldor/` |
| bundle | verify compile stamp | Checks `build/aldor/.aldor-compile-*` |
| test | placeholder test runner | Writes `report/test/aldor-*.ok` |

## Detection

- Markers: `**/*.ad`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `aldor` (override with `ALDOR` env or `aldor_binary` config)

## License

Apache License 2.0.
