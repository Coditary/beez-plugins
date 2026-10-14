# kroc

Official KRoC compiler plugin — KRoC occam — compile .occ sources with occ21.

Plugin ID: **`coditary/kroc`**

## Install

```lua
reqpack { beez = { { name = "coditary/kroc", version = "1.0.0", source = "github:Coditary/beez-kroc" } } }
```

## Usage

```lua
configure({ { "coditary/kroc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[kroc]
beez -s coditary/kroc:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `kroc` | Verify toolchain, create `build/kroc/.kroc-setup` |
| compile | `kroc` | Compile sources to `build/kroc/` |
| bundle | `kroc` | Verify compile artifacts |
| test | `kroc` | Writes `report/test/kroc-*.ok` |

## Detection

- Markers: **/*.occ
- Entry points: `main.occ`, `src/main.occ`, or first non-test `*.occ`

## License

Apache License 2.0.
