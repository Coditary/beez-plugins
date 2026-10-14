# tidal

Official TidalCycles plugin — render algorithmic patterns (`*.tidal`, Haskell) to WAV.

Plugin ID: **`coditary/tidal`**

## Install

```lua
reqpack { beez = { { name = "coditary/tidal", version = "1.0.0", source = "github:Coditary/beez-tidal" } } }
```

## Usage

```lua
configure({ { "coditary/tidal", {} } })
```

```bash
beez -p compile[tidal]
beez -s tidal:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `tidal` | `tidal --version` | Verifies TidalCycles binary |
| compile | `tidal` | `tidal --silent --dump=wav:…` | Renders `build/tidal/bin/app.wav` |
| bundle | `tidal` | verify output | Checks rendered WAV |
| test | `tidal` | render test output | Validates pattern when test files exist |

## Detection

- Markers: `**/*.tidal`
- Entry point: first non-test `*.tidal`, or `entry_source` in configure()
- Render duration: `10` seconds (code), `5` seconds (debug)
- Tests: `test/**/*.tidal`, `test_*.tidal`, `*_test.tidal`

## License

Apache License 2.0.
