# antlr

Official ANTLR plugin — generate parsers from ANTLR grammar files.

Plugin ID: **`coditary/antlr`**

## Install

```lua
reqpack { beez = { { name = "coditary/antlr", version = "1.0.0", source = "github:Coditary/beez-antlr" } } }
```

## Usage

```lua
configure({ { "coditary/antlr", { language = "C" } } })
```

```bash
beez -p compile[antlr]
beez -s antlr:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `antlr` | `antlr4` | Verifies ANTLR binary |
| compile | `antlr` | `antlr4 -Dlanguage=C -o …` | Generates parser sources in `build/antlr/bin/` |
| bundle | `antlr` | verify output | Checks generated C sources |
| test | `antlr` | regenerate test output | Validates grammar generation |

## Detection

- Markers: `**/*.g4`, `**/*.g3`
- Entry point: `Grammar.g4` / `grammar.g4`, or first non-test grammar file, or `entry_source` in configure()
- Default language: `C` (configurable via `language` in configure())

## License

Apache License 2.0.
