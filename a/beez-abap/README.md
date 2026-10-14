# abap

SAP ABAP — abaplint syntax check with auto-detected .abap sources.

Plugin ID: **`coditary/abap`**

## Install

```lua
reqpack { beez = { { name = "coditary/abap", version = "1.0.0", source = "github:Coditary/beez-abap" } } }
```

## Usage

```lua
configure({ { "coditary/abap", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[abap]
beez -s abap:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Run abaplint syntax check on ABAP sources |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/abap-*.ok` |

## Detection

- Markers: abaplint.json, **/abaplint.json, **/*.abap
- Entry points: `main.abap`, `src/main.abap`, or first non-test source file
- Setup verifies `abaplint` and `abap` on PATH. Compile runs `abaplint` syntax check.

## License

Apache License 2.0.
