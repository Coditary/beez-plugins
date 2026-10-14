# vextab

Official VexTab plugin — render guitar tab notation (`*.vextab`) to SVG via `vextab-render`.

Plugin ID: **`coditary/vextab`**

## Install

```lua
reqpack { beez = { { name = "coditary/vextab", version = "1.0.0", source = "github:Coditary/beez-vextab" } } }
```

## Usage

```lua
configure({ { "coditary/vextab", {} } })
```

```bash
beez -p compile[vextab]
beez -s vextab:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `vextab` | `vextab-render --version` | Verifies VexTab renderer binary |
| compile | `vextab` | `vextab-render -i … -o …` | Generates `build/vextab/bin/app.svg` |
| bundle | `vextab` | verify output | Checks generated SVG |
| test | `vextab` | re-render to test SVG | Validates VexTab sources when test files exist |

## Detection

- Markers: `**/*.vextab`
- Entry point: first non-test `*.vextab`, or `entry_source` in configure()
- Tests: `test/**/*.vextab`, `test_*.vextab`, `*_test.vextab`

## License

Apache License 2.0.
