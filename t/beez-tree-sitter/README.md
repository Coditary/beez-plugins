# tree-sitter

Official Tree-sitter plugin — generate incremental parsers from `grammar.js`.

Plugin ID: **`coditary/tree-sitter`**

## Install

```lua
reqpack { beez = { { name = "coditary/tree-sitter", version = "1.0.0", source = "github:Coditary/beez-tree-sitter" } } }
```

## Usage

```lua
configure({ { "coditary/tree-sitter", {} } })
```

```bash
beez -p compile[tree-sitter]
beez -s tree-sitter:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `tree-sitter` | `tree-sitter --version` | Verifies Tree-sitter CLI |
| compile | `tree-sitter` | `tree-sitter generate` | Copies `src/parser.c` to `build/tree-sitter/bin/` |
| bundle | `tree-sitter` | verify output | Checks generated parser |
| test | `tree-sitter` | `tree-sitter test` | Runs corpus tests when present |

## Detection

- Markers: `grammar.js`, `**/grammar.js`, `bindings/node/binding.gyp`
- Entry point: shallowest `grammar.js`, or `entry_source` in configure()
- Grammar root: directory containing `grammar.js`
- Tests: `test/corpus/**` or `tests/corpus/**`

## License

Apache License 2.0.
