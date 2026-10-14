# patscc

Official ATS Postiats plugin — `patscc -o` compile with auto-detected `.dats` and `.sats` sources.

Plugin ID: **`coditary/patscc`**

## Install

```lua
reqpack { beez = { { name = "coditary/patscc", version = "1.0.0", source = "github:Coditary/beez-patscc" } } }
```

## Usage

```lua
configure({ { "coditary/patscc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[patscc]
beez -s patscc:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `patscc` | Writes setup stamp under `build/patscc/` |
| compile | `patscc -o` on `.dats` targets | Writes compile stamp under `build/patscc/` |
| bundle | verify compile stamp | Checks `build/patscc/.patscc-compile-*` |
| test | placeholder test runner | Writes `report/test/patscc-*.ok` |

## Detection

- Markers: `**/*.dats`, `**/*.sats`
- Compile targets: auto-detected source files (excluding test paths)
- Binary: `patscc` (override with `PATSCC` env or `patscc_binary` config)

## License

Apache License 2.0.
