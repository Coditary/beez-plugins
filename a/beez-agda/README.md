# agda

Official Agda compiler plugin — `agda -c` type-check and compile with auto-detected `.agda` targets.

Plugin ID: **`coditary/agda`**

## Install

```lua
reqpack { beez = { { name = "coditary/agda", version = "1.0.0", source = "github:Coditary/beez-agda" } } }
```

## Usage

```lua
configure({ { "coditary/agda", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[agda]
beez -s agda:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `agda` | Writes setup stamp under `build/agda/` |
| compile | `agda -c` on all sources | Writes compile stamp under `build/agda/` |
| bundle | verify compile stamp | Checks `build/agda/.agda-compile-*` |
| test | placeholder test runner | Writes `report/test/agda-*.ok` |

## Detection

- Markers: `**/*.agda`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `agda` (override with `AGDA` env or `agda_binary` config)

## License

Apache License 2.0.
