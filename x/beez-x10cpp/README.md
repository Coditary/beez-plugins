# x10cpp

X10 — x10c++ native C++ backend for .x10 sources

Plugin ID: **`coditary/x10cpp`**

## Install

```lua
reqpack { beez = { { name = "coditary/x10cpp", version = "1.0.0", source = "github:Coditary/beez-x10cpp" } } }
```

## Usage

```lua
configure({ { "coditary/x10cpp", {} } })
```

```bash
beez -p compile[x10cpp]
beez -s x10cpp:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `x10cpp` | Verify toolchain, prepare build directory |
| compile | `x10cpp` | Compile sources, write stamp under `build/x10cpp/` |
| bundle | `x10cpp` | Verify compile stamp |
| test | `x10cpp` | Run tests, write `report/test/x10cpp-*.ok` |

## License

Apache License 2.0.
