# tlaplus

Official TLA+ plugin — run TLC model checker on formal specifications (`*.tla`, `*.cfg`).

Plugin ID: **`coditary/tlaplus`**

## Install

```lua
reqpack { beez = { { name = "coditary/tlaplus", version = "1.0.0", source = "github:Coditary/beez-tlaplus" } } }
```

## Usage

```lua
configure({ { "coditary/tlaplus", {} } })
```

```bash
beez -p compile[tlaplus]
beez -s tlaplus:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `tlaplus` | `tlc -help` | Verifies TLC model checker |
| compile | `tlaplus` | `tlc -config … spec.tla` | Runs model check, writes `build/tlaplus/bin/check.out` |
| bundle | `tlaplus` | verify output | Checks model check log |
| test | `tlaplus` | `tlc …` | Re-runs TLC when test specs exist |

## Detection

- Markers: `**/*.tla`, `**/*.cfg`
- Entry point: first non-test `*.tla`, or `entry_source` in configure()
- TLC config: matching `*.cfg` (same basename), or `config_source` in configure()
- Tests: `test/**/*.tla`, `test_*.tla`, `*_test.tla`

## License

Apache License 2.0.
