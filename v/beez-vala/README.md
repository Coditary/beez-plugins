# vala

Vala — valac GObject-to-C compiler with meson.build detection

Plugin ID: **`coditary/vala`**

## Install

```lua
reqpack { beez = { { name = "coditary/vala", version = "1.0.0", source = "github:Coditary/beez-vala" } } }
```

## Usage

```lua
configure({ { "coditary/vala", {} } })
```

```bash
beez -p compile[vala]
beez -s vala:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `vala` | Verify toolchain, prepare build directory |
| compile | `vala` | Compile sources, write stamp under `build/vala/` |
| bundle | `vala` | Verify compile stamp |
| test | `vala` | Run tests, write `report/test/vala-*.ok` |

## License

Apache License 2.0.
