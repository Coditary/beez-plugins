# bison

Official GNU Bison/Yacc plugin — generate C parsers from Yacc/Bison grammar files.

Plugin ID: **`coditary/bison`**

## Install

```lua
reqpack { beez = { { name = "coditary/bison", version = "1.0.0", source = "github:Coditary/beez-bison" } } }
```

## Usage

```lua
configure({ { "coditary/bison", {} } })
```

```bash
beez -p compile[bison]
beez -s bison:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `bison` | `bison --version` | Verifies Bison binary |
| compile | `bison` | `bison --defines --output=…` | Generates `build/bison/bin/parser.tab.c` |
| bundle | `bison` | verify output | Checks generated parser and header |
| test | `bison` | `bison --report=all …` | Validates grammar with report |

## Detection

- Markers: `**/*.y`, `**/*.yy`, `**/*.yacc`
- Entry point: `grammar.y` / `parser.y`, or first non-test grammar file, or `entry_source` in configure()
- Output: `parser.tab.c` and `parser.tab.h` (code profile), verbose flags (debug profile)

## License

Apache License 2.0.
