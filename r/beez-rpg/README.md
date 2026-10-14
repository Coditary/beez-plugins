# rpg

IBM ILE RPG — CRTBNDRPG compile for .rpgle and .sqlrpgle sources

Plugin ID: **`coditary/rpg`**

## Install

```lua
reqpack { beez = { { name = "coditary/rpg", version = "1.0.0", source = "github:Coditary/beez-rpg" } } }
```

## Usage

```lua
configure({ { "coditary/rpg", {} } })
```

```bash
beez -p compile[rpg]
beez -s rpg:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `rpg` | Verify toolchain, prepare build directory |
| compile | `rpg` | Compile sources, write stamp under `build/rpg/` |
| bundle | `rpg` | Verify compile stamp |
| test | `rpg` | Run tests, write `report/test/rpg-*.ok` |

## License

Apache License 2.0.
