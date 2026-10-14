# openplc

OpenPLC — IEC 61131-3 Structured Text / ladder logic compiler for `*.st` and `*.plc` sources.

Plugin ID: **`coditary/openplc`**

## Install

```lua
reqpack { beez = { { name = "coditary/openplc", version = "1.0.0", source = "github:Coditary/beez-openplc" } } }
```

## Usage

```lua
configure({ { "coditary/openplc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[openplc]
beez -s openplc:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Verify `openplc` compiler |
| compile | `compile:code` / `compile:debug` | Compile ST/PLC sources to C in `build/openplc/gen` |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/openplc-*.ok` |

## Detection

- Markers: `**/*.st`, `**/*.plc`
- Entry points: `main.st`, `main.plc`, `program.st`, or first non-test source file
- Compiles with `openplc -o` (override via `OPENPLC` env)

## License

Apache License 2.0.
