# beta

Official Mjølner BETA plugin — `beta` compile with auto-detected `.bet` sources.

Plugin ID: **`coditary/beta`**

## Install

```lua
reqpack { beez = { { name = "coditary/beta", version = "1.0.0", source = "github:Coditary/beez-beta" } } }
```

## Usage

```lua
configure({ { "coditary/beta", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[beta]
beez -s beta:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `beta` | Writes setup stamp under `build/beta/` |
| compile | `beta` on all sources | Writes compile stamp under `build/beta/` |
| bundle | verify compile stamp | Checks `build/beta/.beta-compile-*` |
| test | placeholder test runner | Writes `report/test/beta-*.ok` |

## Detection

- Markers: `**/*.bet`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `beta` (override with `BETA` env or `beta_binary` config)

## License

Apache License 2.0.
