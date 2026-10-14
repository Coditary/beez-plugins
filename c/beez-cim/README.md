# cim

GNU Cim — Simula-to-C compiler for .sim sources

Plugin ID: **`coditary/cim`**

## Install

```lua
reqpack { beez = { { name = "coditary/cim", version = "1.0.0", source = "github:Coditary/beez-cim" } } }
```

## Usage

```lua
configure({ { "coditary/cim", {} } })
```

```bash
beez -p compile[cim]
beez -s cim:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `cim` | Verify toolchain, prepare build directory |
| compile | `cim` | Compile sources, write stamp under `build/cim/` |
| bundle | `cim` | Verify compile stamp |
| test | `cim` | Run tests, write `report/test/cim-*.ok` |

## License

Apache License 2.0.
