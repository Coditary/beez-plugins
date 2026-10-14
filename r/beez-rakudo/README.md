# rakudo

Rakudo Raku (Perl 6) compiler — `zef` dependency install, `raku -c` syntax check, and `prove6` tests.

Plugin ID: **`coditary/rakudo`**

## Install

```lua
reqpack { beez = { { name = "coditary/rakudo", version = "1.0.0", source = "github:Coditary/beez-rakudo" } } }
```

## Usage

```lua
configure({ { "coditary/rakudo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `zef install --depsonly .` | Skipped when no `META6.json`; verifies `raku` binary |
| compile | `raku -c` / `rakudo-moar -c` | Syntax-check all `.raku`, `.rakumod`, `.pm6` sources |
| bundle | verify compile stamp | Checks `build/rakudo/.rakudo-compile` |
| test | `prove6 -r t/` or `raku t/*.t` | Writes `report/test/rakudo-*.ok` |

## Detection

- Markers: `META6.json`, `**/*.raku`, `**/*.rakumod`, `**/*.pm6`
- Tests: `t/*.t`, `t/**/*.t`, `t/*.rakutest`
- Binaries: `raku`, `zef`, `prove6` (override with `RAKU` env or config)

## License

Apache License 2.0.
