# pegjs

Official PEG.js/Peggy plugin — generate JavaScript parsers from PEG grammar files.

Plugin ID: **`coditary/pegjs`**

## Install

```lua
reqpack { beez = { { name = "coditary/pegjs", version = "1.0.0", source = "github:Coditary/beez-pegjs" } } }
```

## Usage

```lua
configure({ { "coditary/pegjs", {} } })
```

```bash
beez -p compile[pegjs]
beez -s pegjs:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `pegjs` | `peggy --version` | Verifies Peggy or PEG.js binary |
| compile | `pegjs` | `peggy -o …` | Generates `build/pegjs/bin/parser.js` |
| bundle | `pegjs` | verify output | Checks generated parser |
| test | `pegjs` | dry-run generation | Validates PEG grammar |

## Detection

- Markers: `**/*.pegjs`, `**/*.peggy`
- Entry point: `grammar.peggy` / `parser.peggy`, or first non-test grammar file, or `entry_source` in configure()
- Output: `parser.js` (code profile), source maps (debug profile)

## License

Apache License 2.0.
