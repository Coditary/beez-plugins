# implicitcad

Official ImplicitCAD plugin — export functional CAD models from ImplicitCAD `*.scad` or Haskell sources via `extopenscad` / `implicitcad`.

Plugin ID: **`coditary/implicitcad`**

## Install

```lua
reqpack { beez = { { name = "coditary/implicitcad", version = "1.0.0", source = "github:Coditary/beez-implicitcad" } } }
```

## Usage

```lua
configure({ { "coditary/implicitcad", {} } })
```

```bash
beez -p compile[implicitcad]
beez -s implicitcad:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `implicitcad` | `extopenscad --version` | Verifies ImplicitCAD binary |
| compile | `implicitcad` | `extopenscad -o …` | Generates `build/implicitcad/app.stl` |
| bundle | `implicitcad` | verify output | Checks exported model |
| test | `implicitcad` | export test output | Validates ImplicitCAD export |

## Detection

- Markers: `**/*.scad` (ImplicitCAD), or `**/*.hs` with `Graphics.Implicit`
- Entry point: first matching source, or `entry_source` in configure()
- Binaries: `extopenscad` (preferred) or `implicitcad`; Haskell sources use `runhaskell`
- Formats: STL (code profile), OBJ (debug profile)

Haskell scripts should read `IMPLICITCAD_OUTPUT` and `IMPLICITCAD_FORMAT` environment variables.

## License

Apache License 2.0.
