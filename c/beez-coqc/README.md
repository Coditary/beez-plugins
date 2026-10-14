# coqc

Official Coq/Rocq plugin — `coqc` compile with auto-detected `_CoqProject` and `.v` sources.

Plugin ID: **`coditary/coqc`**

## Install

```lua
reqpack { beez = { { name = "coditary/coqc", version = "1.0.0", source = "github:Coditary/beez-coqc" } } }
```

## Usage

```lua
configure({ { "coditary/coqc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[coqc]
beez -s coqc:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `coqc` | Writes setup stamp under `build/coqc/` |
| compile | `coqc` on all sources | Writes compile stamp under `build/coqc/` |
| bundle | verify compile stamp | Checks `build/coqc/.coqc-compile-*` |
| test | placeholder test runner | Writes `report/test/coqc-*.ok` |

## Detection

- Markers: `_CoqProject`, `**/_CoqProject`, `**/*.v`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `coqc` (override with `COQC` env or `coqc_binary` config)

## License

Apache License 2.0.
