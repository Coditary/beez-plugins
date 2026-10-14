# turing

Official turing compiler plugin — Object Oriented Turing — tpc compile with auto-detected **/*.t targets.

Plugin ID: **`coditary/turing`**

## Install

```lua
reqpack { beez = { { name = "coditary/turing", version = "1.0.0", source = "github:Coditary/beez-turing" } } }
```

## Usage

```lua
configure({ { "coditary/turing", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[turing]
beez -s turing:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `tpc` | Prepare `build/turing/` |
| compile | `tpc` on sources | Writes artifacts under `build/turing/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/turing-*.ok` |

## Detection

- Markers: `**/*.t`
- Compile OOT `.t` sources with `tpc -o`.
- Binary: `tpc` (override with `TPC` env or `turing_binary` config)

## License

Apache License 2.0.
