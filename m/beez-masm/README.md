# masm

MASM — Microsoft Macro Assembler (ml/ml64).

Plugin ID: **`coditary/masm`**

## Install

```lua
reqpack { beez = { { name = "coditary/masm", version = "1.0.0", source = "github:Coditary/beez-masm" } } }
```

## Usage

```lua
configure({ { "coditary/masm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[masm]
beez -s masm:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Assemble sources with ml/ml64 |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/masm-*.ok` |

## Detection

- Markers: **/*.asm
- Entry points: `main.asm`, `src/main.asm`, or first non-test source file
- Uses `ml64` (or `ml`) with `/Fo` for object output.

## License

Apache License 2.0.
