# marst

GNU marst — ALGOL 60 to C translator for `.alg` sources.

Plugin ID: **`coditary/marst`**

## Install

```lua
reqpack { beez = { { name = "coditary/marst", version = "1.0.0", source = "github:Coditary/beez-marst" } } }
```

## Usage

```lua
configure({ { "coditary/marst", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[marst]
beez -s marst:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify `marst` and `gcc` |
| compile | `compile:code` / `compile:debug` | Translate `.alg` to C and link with `-lalgol -lm` |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/marst-*.ok` |

## Detection

- Markers: `**/*.alg`
- Entry points: `main.alg`, `src/main.alg`, or first non-test source file
- Translates with `marst -o`, then links with `gcc -lalgol -lm`

## License

Apache License 2.0.
