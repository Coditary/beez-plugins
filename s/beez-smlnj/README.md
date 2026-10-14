# smlnj

Official SML/NJ compiler plugin — SML/NJ interactive compiler — CM.make with auto-detected .sml targets.

Plugin ID: **`coditary/smlnj`**

## Install

```lua
reqpack { beez = { { name = "coditary/smlnj", version = "1.0.0", source = "github:Coditary/beez-smlnj" } } }
```

## Usage

```lua
configure({ { "coditary/smlnj", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[smlnj]
beez -s coditary/smlnj:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `smlnj` | Verify toolchain, create `build/smlnj/.smlnj-setup` |
| compile | `smlnj` | Compile sources to `build/smlnj/` |
| bundle | `smlnj` | Verify compile artifacts |
| test | `smlnj` | Writes `report/test/smlnj-*.ok` |

## Detection

- Markers: **/*.sml, sources.cm
- Entry points: `main.sml`, `src/main.sml`, or first non-test `*.sml`

## License

Apache License 2.0.
