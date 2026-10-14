# oz

Official Oz compiler plugin — Mozart ozc — compile .oz sources to .ozf bytecode.

Plugin ID: **`coditary/oz`**

## Install

```lua
reqpack { beez = { { name = "coditary/oz", version = "1.0.0", source = "github:Coditary/beez-oz" } } }
```

## Usage

```lua
configure({ { "coditary/oz", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[oz]
beez -s coditary/oz:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `oz` | Verify toolchain, create `build/oz/.oz-setup` |
| compile | `oz` | Compile sources to `build/oz/` |
| bundle | `oz` | Verify compile artifacts |
| test | `oz` | Writes `report/test/oz-*.ok` |

## Detection

- Markers: **/*.oz
- Entry points: `main.oz`, `src/main.oz`, or first non-test `*.oz`

## License

Apache License 2.0.
