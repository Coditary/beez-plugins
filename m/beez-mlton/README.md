# mlton

Official MLton compiler plugin — MLton SML whole-program compiler — mlton with .sml and .mlb targets.

Plugin ID: **`coditary/mlton`**

## Install

```lua
reqpack { beez = { { name = "coditary/mlton", version = "1.0.0", source = "github:Coditary/beez-mlton" } } }
```

## Usage

```lua
configure({ { "coditary/mlton", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[mlton]
beez -s coditary/mlton:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `mlton` | Verify toolchain, create `build/mlton/.mlton-setup` |
| compile | `mlton` | Compile sources to `build/mlton/` |
| bundle | `mlton` | Verify compile artifacts |
| test | `mlton` | Writes `report/test/mlton-*.ok` |

## Detection

- Markers: **/*.sml, **/*.mlb
- Entry points: `main.sml`, `src/main.sml`, or first non-test `*.sml`

## License

Apache License 2.0.
