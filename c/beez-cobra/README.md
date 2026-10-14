# cobra

Official Cobra plugin — `cobra - compile` to .NET CIL with auto-detected `.cobra` sources.

Plugin ID: **`coditary/cobra`**

## Install

```lua
reqpack { beez = { { name = "coditary/cobra", version = "1.0.0", source = "github:Coditary/beez-cobra" } } }
```

## Usage

```lua
configure({ { "coditary/cobra", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[cobra]
beez -s cobra:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `cobra` | Writes setup stamp under `build/cobra/` |
| compile | `cobra - compile:` on all `.cobra` sources | Writes compile stamp under `build/cobra/` |
| bundle | verify compile stamp | Checks `build/cobra/.cobra-compile-*` |
| test | placeholder test runner | Writes `report/test/cobra-*.ok` |

## Detection

- Markers: `**/*.cobra`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `cobra` (override with `COBRA` env or `cobra_binary` config)

## License

Apache License 2.0.
