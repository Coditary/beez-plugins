# chuck

Official ChucK plugin — render strongly-timed audio scripts (`*.ck`) to WAV.

Plugin ID: **`coditary/chuck`**

## Install

```lua
reqpack { beez = { { name = "coditary/chuck", version = "1.0.0", source = "github:Coditary/beez-chuck" } } }
```

## Usage

```lua
configure({ { "coditary/chuck", {} } })
```

```bash
beez -p compile[chuck]
beez -s chuck:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `chuck` | `chuck --version` | Verifies ChucK binary |
| compile | `chuck` | `chuck --silent --dump=wav:…` | Renders `build/chuck/bin/app.wav` |
| bundle | `chuck` | verify output | Checks rendered WAV |
| test | `chuck` | render test output | Validates script when test files exist |

## Detection

- Markers: `**/*.ck`
- Entry point: first non-test `*.ck`, or `entry_source` in configure()
- Render duration: `10.0::second` (code), `5.0::second` (debug)
- Tests: `test/**/*.ck`, `test_*.ck`, `*_test.ck`

## License

Apache License 2.0.
