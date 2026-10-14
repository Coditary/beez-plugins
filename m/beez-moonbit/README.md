# moonbit

Official MoonBit compiler — `moon build` with auto-detected `moon.pkg.json` package layout.

Plugin ID: **`coditary/moonbit`**

## Install

```lua
reqpack { beez = { { name = "coditary/moonbit", version = "1.0.0", source = "github:Coditary/beez-moonbit" } } }
```

## Usage

```lua
configure({ { "coditary/moonbit", {} } })
```

```bash
beez -p compile[moonbit]
beez -s moonbit:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `moonbit` | `moon version` | Verifies MoonBit compiler binary |
| compile | `moonbit` | `moon build` | Wasm/native package build |
| bundle | `moonbit` | verify binary | Checks `build/moonbit/bin/app` |
| test | `moonbit` | `moon test` | Skipped when no test files are detected |

## Detection

- Markers: `moon.pkg.json`, `**/*.mbt`
- Project root: directory containing `moon.pkg.json`
- Tests: `*_test.mbt`, `test/**/*.mbt`, `tests/**/*.mbt`

## License

Apache License 2.0.
