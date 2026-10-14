# ats

Official ATS2 Postiats compiler plugin — `patscc` compile with auto-detected `*.dats`/`*.sats` targets.

Plugin ID: **`coditary/ats`**

## Install

```lua
reqpack { beez = { { name = "coditary/ats", version = "1.0.0", source = "github:Coditary/beez-ats" } } }
```

## Usage

```lua
configure({ { "coditary/ats", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ats]
beez -s coditary/ats:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `patscc` | Creates `build/ats/.ats-setup` |
| compile | `patscc -o` | Compiles all non-test `*.dats` |
| bundle | verify compile stamp | Checks `build/ats/.ats-compile-*` |
| test | verify binary | Checks compiled executable exists |

## Detection

- Markers: `**/*.dats`, `**/*.sats`
- Compile targets: all non-test `*.dats` files
- Binary: `patscc` (override with `PATSCC` env or `patscc_binary` config)

## License

Apache License 2.0.
