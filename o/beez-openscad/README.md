# openscad

Official OpenSCAD plugin — export parametric CAD models from `*.scad` sources via `openscad`.

Plugin ID: **`coditary/openscad`**

## Install

```lua
reqpack { beez = { { name = "coditary/openscad", version = "1.0.0", source = "github:Coditary/beez-openscad" } } }
```

## Usage

```lua
configure({ { "coditary/openscad", {} } })
```

```bash
beez -p compile[openscad]
beez -s openscad:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `openscad` | `openscad --version` | Verifies OpenSCAD binary |
| compile | `openscad` | `openscad -o …` | Generates `build/openscad/app.stl` |
| bundle | `openscad` | verify output | Checks exported model |
| test | `openscad` | export test output | Validates CAD model export |

## Detection

- Markers: `**/*.scad`
- Entry point: first non-test `.scad` file, or `entry_source` in configure()
- Formats: STL (code profile), OBJ (debug profile)

## License

Apache License 2.0.
