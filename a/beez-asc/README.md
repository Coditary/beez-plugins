# asc

ActionScript AVM2 — asc/mxmlc compiler for .as sources.

Plugin ID: **`coditary/asc`**

## Install

```lua
reqpack { beez = { { name = "coditary/asc", version = "1.0.0", source = "github:Coditary/beez-asc" } } }
```

## Usage

```lua
configure({ { "coditary/asc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[asc]
beez -s asc:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Compile ActionScript with asc |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/asc-*.ok` |

## Detection

- Markers: **/*.as
- Entry points: `main.as`, `src/main.as`, or first non-test source file
- Uses `asc` when available, falls back to `mxmlc` for compilation.

## License

Apache License 2.0.
