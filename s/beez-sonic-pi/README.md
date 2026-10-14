# sonic-pi

Official Sonic Pi plugin — render live-coding Ruby buffers (`*.rb`) to WAV.

Plugin ID: **`coditary/sonic-pi`**

## Install

```lua
reqpack { beez = { { name = "coditary/sonic-pi", version = "1.0.0", source = "github:Coditary/beez-sonic-pi" } } }
```

## Usage

```lua
configure({ { "coditary/sonic-pi", {} } })
```

```bash
beez -p compile[sonic-pi]
beez -s sonic-pi:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `sonic-pi` | `sonic-pi --version` | Verifies Sonic Pi binary |
| compile | `sonic-pi` | `sonic-pi --silent --dump=wav:…` | Renders `build/sonic-pi/bin/app.wav` |
| bundle | `sonic-pi` | verify output | Checks rendered WAV |
| test | `sonic-pi` | render test output | Validates buffer when test files exist |

## Detection

- Markers: `**/*.rb` (prefers `sonic-pi/`, `buffers/`, `pi/` paths)
- Entry point: first non-test `*.rb`, or `entry_source` in configure()
- Render duration: `10.0` seconds (code), `5.0` seconds (debug)
- Tests: `test/**/*.rb`, `test_*.rb`, `*_test.rb`

## License

Apache License 2.0.
