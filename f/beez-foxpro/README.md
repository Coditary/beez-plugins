# foxpro

Visual FoxPro — P-Code compile for .prg and .scx sources

Plugin ID: **`coditary/foxpro`**

## Install

```lua
reqpack { beez = { { name = "coditary/foxpro", version = "1.0.0", source = "github:Coditary/beez-foxpro" } } }
```

## Usage

```lua
configure({ { "coditary/foxpro", {} } })
```

```bash
beez -p compile[foxpro]
beez -s foxpro:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `foxpro` | Verify toolchain, prepare build directory |
| compile | `foxpro` | Compile sources, write stamp under `build/foxpro/` |
| bundle | `foxpro` | Verify compile stamp |
| test | `foxpro` | Run tests, write `report/test/foxpro-*.ok` |

## License

Apache License 2.0.
