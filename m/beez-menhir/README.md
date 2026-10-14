# menhir

Official Menhir plugin — generate OCaml parsers from Menhir grammar files.

Plugin ID: **`coditary/menhir`**

## Install

```lua
reqpack { beez = { { name = "coditary/menhir", version = "1.0.0", source = "github:Coditary/beez-menhir" } } }
```

## Usage

```lua
configure({ { "coditary/menhir", {} } })
```

```bash
beez -p compile[menhir]
beez -s menhir:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `menhir` | `menhir --version` | Verifies Menhir binary |
| compile | `menhir` | `menhir --base parser …` | Generates `build/menhir/bin/parser.ml` |
| bundle | `menhir` | verify output | Checks generated parser and interface |
| test | `menhir` | `menhir --only-check …` | Validates grammar without codegen |

## Detection

- Markers: `**/*.mly`
- Entry point: `parser.mly` / `grammar.mly`, or first non-test grammar file, or `entry_source` in configure()
- Output: `parser.ml` and `parser.mli` (code profile), verbose flags (debug profile)

## License

Apache License 2.0.
