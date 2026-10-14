# pike

Official Pike compiler plugin — Pike bytecode compiler — pike -b with .pike and .pmod targets.

Plugin ID: **`coditary/pike`**

## Install

```lua
reqpack { beez = { { name = "coditary/pike", version = "1.0.0", source = "github:Coditary/beez-pike" } } }
```

## Usage

```lua
configure({ { "coditary/pike", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[pike]
beez -s coditary/pike:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `pike` | Verify toolchain, create `build/pike/.pike-setup` |
| compile | `pike` | Compile sources to `build/pike/` |
| bundle | `pike` | Verify compile artifacts |
| test | `pike` | Writes `report/test/pike-*.ok` |

## Detection

- Markers: **/*.pike, **/*.pmod
- Entry points: `main.pike`, `src/main.pike`, or first non-test `*.pike`

## License

Apache License 2.0.
