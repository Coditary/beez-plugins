# parrot

Historical Parrot VM compiler — `parrot -o` on PIR/PASM sources with auto-detected targets.

Plugin ID: **`coditary/parrot`**

## Install

```lua
reqpack { beez = { { name = "coditary/parrot", version = "1.0.0", source = "github:Coditary/beez-parrot" } } }
```

## Usage

```lua
configure({ { "coditary/parrot", {} } })
```

```bash
beez -p compile[parrot]
beez -s parrot:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `parrot` binary | Prepares `build/parrot/` |
| compile | `parrot -o build/parrot/*.pbc` | From `.pir`/`.pasm` sources |
| bundle | verify bytecode | Checks `build/parrot/**/*.pbc` |
| test | `prove -e parrot t/` | When `t/` directory exists |

## Detection

- Markers: `**/*.pir`, `**/*.pasm`, `**/*.pbc`
- Compile targets: all non-test `.pir` and `.pasm` files
- Binary: `parrot` (override with `PARROT` env or `parrot_binary` config)
- Scope: `parrot`

## License

Apache License 2.0.
