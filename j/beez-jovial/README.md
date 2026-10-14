# jovial

JOVIAL J73 military programming language compiler.

Plugin ID: **`coditary/jovial`**

## Install

```lua
reqpack { beez = { { name = "coditary/jovial", version = "1.0.0", source = "github:Coditary/beez-jovial" } } }
```

## Usage

```lua
configure({ { "coditary/jovial", {} } })
workflows({ build = "coditary/jovial:build" })
```

```bash
beez -p compile[jovial]
beez -s jovial:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `jovial` | Verify `jovial` binary, prepare `build/jovial/` |
| compile | `jovial` | Compile JOVIAL .jov sources to object files |
| bundle | `jovial` | Verify JOVIAL object file artifacts |
| test | `jovial` | Verify JOVIAL build outputs exist |

## Detection

- Markers: **/*.jov
- Binary: `jovial` (override with `JOVIAL` env or `jovial_binary` config)

## License

Apache License 2.0.
