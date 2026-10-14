# solidity

Solidity — solc EVM bytecode and Foundry forge build for .sol contracts

Plugin ID: **`coditary/solidity`**

## Install

```lua
reqpack { beez = { { name = "coditary/solidity", version = "1.0.0", source = "github:Coditary/beez-solidity" } } }
```

## Usage

```lua
configure({ { "coditary/solidity", {} } })
```

```bash
beez -p compile[solidity]
beez -s solidity:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `solidity` | Verify toolchain, prepare build directory |
| compile | `solidity` | Compile sources, write stamp under `build/solidity/` |
| bundle | `solidity` | Verify compile stamp |
| test | `solidity` | Run tests, write `report/test/solidity-*.ok` |

## License

Apache License 2.0.
