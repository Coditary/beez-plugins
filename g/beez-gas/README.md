# gas

GNU Assembler — as/gcc -c for .s and .S sources.

Plugin ID: **`coditary/gas`**

## Install

```lua
reqpack { beez = { { name = "coditary/gas", version = "1.0.0", source = "github:Coditary/beez-gas" } } }
```

## Usage

```lua
configure({ { "coditary/gas", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[gas]
beez -s gas:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Assemble sources with as/gcc -c |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/gas-*.ok` |

## Detection

- Markers: **/*.s, **/*.S
- Entry points: `main.s`, `src/main.s`, or first non-test source file
- Uses `as -o` for `.s` and `gcc -c` for `.S` sources.

## License

Apache License 2.0.
