# sphinx

Official C-- IR plugin — Sphinx compiler with auto-detected `.c--` sources.

Plugin ID: **`coditary/sphinx`**

## Install

```lua
reqpack { beez = { { name = "coditary/sphinx", version = "1.0.0", source = "github:Coditary/beez-sphinx" } } }
```

## Usage

```lua
configure({ { "coditary/sphinx", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[sphinx]
beez -s sphinx:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `sphinx` | Writes setup stamp under `build/sphinx/` |
| compile | `sphinx -o` on all `.c--` sources | Writes compile stamp under `build/sphinx/` |
| bundle | verify compile stamp | Checks `build/sphinx/.sphinx-compile-*` |
| test | placeholder test runner | Writes `report/test/sphinx-*.ok` |

## Detection

- Markers: `**/*.c--`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `sphinx` (override with `SPHINX_CC` env or `sphinx_binary` config)

## License

Apache License 2.0.
