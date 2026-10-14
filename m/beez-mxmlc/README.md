# mxmlc

Adobe Flex mxmlc — compiles MXML and ActionScript to SWF.

Plugin ID: **`coditary/mxmlc`**

## Install

```lua
reqpack { beez = { { name = "coditary/mxmlc", version = "1.0.0", source = "github:Coditary/beez-mxmlc" } } }
```

## Usage

```lua
configure({ { "coditary/mxmlc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[mxmlc]
beez -s mxmlc:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Compile MXML/ActionScript with mxmlc |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/mxmlc-*.ok` |

## Detection

- Markers: **/*.mxml, **/*.as
- Entry points: `main.mxml`, `src/main.mxml`, or first non-test source file
- Compiles `.mxml` entry points with `mxmlc`, falling back to `.as` sources.

## License

Apache License 2.0.
