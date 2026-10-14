# cadquery

Official CadQuery plugin — export parametric CAD models from Python scripts via `python3` + `cadquery`.

Plugin ID: **`coditary/cadquery`**

## Install

```lua
reqpack { beez = { { name = "coditary/cadquery", version = "1.0.0", source = "github:Coditary/beez-cadquery" } } }
```

## Usage

```lua
configure({ { "coditary/cadquery", {} } })
```

```bash
beez -p compile[cadquery]
beez -s cadquery:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `cadquery` | `python3 -c "import cadquery"` | Verifies Python3 and CadQuery |
| compile | `cadquery` | `python3 script.py` | Exports to `build/cadquery/app.stl` |
| bundle | `cadquery` | verify output | Checks exported model |
| test | `cadquery` | run test script | Validates CadQuery export |

## Detection

- Markers: `**/cadquery/**/*.py`, or `**/*.py` with `import cadquery` / `from cadquery`
- Entry point: first matching CadQuery script, or `entry_source` in configure()
- Formats: STL (code profile), OBJ (debug profile)

Scripts should read `CADQUERY_OUTPUT` and `CADQUERY_FORMAT` environment variables to export the model.

## License

Apache License 2.0.
