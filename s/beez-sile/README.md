# sile

Official SILE typesetter plugin — HarfBuzz text shaping with auto-detected entry point.

Plugin ID: **`coditary/sile`**

## Install

```lua
reqpack { beez = { { name = "coditary/sile", version = "1.0.0", source = "github:Coditary/beez-sile" } } }
```

## Usage

```lua
configure({ { "coditary/sile", {} } })
```

```bash
beez -p compile[sile]
beez -s sile:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `sile` | `sile --version` | Verifies SILE binary |
| compile | `sile` | `sile main.sil -o build/sile/out/app.pdf` | PDF output |
| bundle | `sile` | verify output | Checks `build/sile/out/app.pdf` |
| test | `test` | `sile tests` or skip | Skipped when no test files detected |

## Detection

- Markers: `**/*.sil`
- Entry points: `main.sil`, `index.sil`, or first root `*.sil`

## License

Apache License 2.0.
