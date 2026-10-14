# faust

Official Faust plugin — compile audio DSP (`*.dsp`) to C++ or WebAssembly.

Plugin ID: **`coditary/faust`**

## Install

```lua
reqpack { beez = { { name = "coditary/faust", version = "1.0.0", source = "github:Coditary/beez-faust" } } }
```

## Usage

```lua
configure({ { "coditary/faust", {} } })
```

```bash
beez -p compile[faust]
beez -s faust:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `faust` | `faust --version` | Verifies Faust binary |
| compile | `faust` | `faust -lang cpp -o …` | Generates `build/faust/bin/app.cpp` |
| bundle | `faust` | verify output | Checks generated C++ file |
| test | `faust` | `faust -lang wasm …` | Optional Wasm validation when tests exist |

## Detection

- Markers: `**/*.dsp`
- Entry point: first non-test `*.dsp`, or `entry_source` in configure()
- Tests: `test/**/*.dsp`, `test_*.dsp`, `*_test.dsp`

## License

Apache License 2.0.
