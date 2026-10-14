# nasm

NASM — Netwide Assembler for .asm and .s sources.

Plugin ID: **`coditary/nasm`**

## Install

```lua
reqpack { beez = { { name = "coditary/nasm", version = "1.0.0", source = "github:Coditary/beez-nasm" } } }
```

## Usage

```lua
configure({ { "coditary/nasm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[nasm]
beez -s nasm:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Assemble sources with nasm -f |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/nasm-*.ok` |

## Detection

- Markers: **/*.asm, **/*.s
- Entry points: `main.asm`, `src/main.asm`, or first non-test source file
- Assembles with `nasm -f elf64` (override via `format` config).

## License

Apache License 2.0.
