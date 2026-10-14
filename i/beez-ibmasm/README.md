# ibmasm

IBM HLASM — High Level Assembler for IBM Basic Assembly (`*.asm`, `*.mac`).

Plugin ID: **`coditary/ibmasm`**

## Install

```lua
reqpack { beez = { { name = "coditary/ibmasm", version = "1.0.0", source = "github:Coditary/beez-ibmasm" } } }
```

## Usage

```lua
configure({ { "coditary/ibmasm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[ibmasm]
beez -s ibmasm:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify `hlasm` assembler |
| compile | `compile:code` / `compile:debug` | Assemble IBM HLASM sources to `.obj` |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/ibmasm-*.ok` |

## Detection

- Markers: `**/*.asm`, `**/*.mac`
- Entry points: `main.asm`, `app.asm`, or first non-test source file
- Assembles with `hlasm SYSIN(...) SYSGO(...)` (override via `HLASM` env)

## License

Apache License 2.0.
