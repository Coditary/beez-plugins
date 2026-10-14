# x10

X10 — x10c JVM backend for .x10 sources with X10.properties

Plugin ID: **`coditary/x10`**

## Install

```lua
reqpack { beez = { { name = "coditary/x10", version = "1.0.0", source = "github:Coditary/beez-x10" } } }
```

## Usage

```lua
configure({ { "coditary/x10", {} } })
```

```bash
beez -p compile[x10]
beez -s x10:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `x10` | Verify toolchain, prepare build directory |
| compile | `x10` | Compile sources, write stamp under `build/x10/` |
| bundle | `x10` | Verify compile stamp |
| test | `x10` | Run tests, write `report/test/x10-*.ok` |

## License

Apache License 2.0.
