# freebasic

FreeBASIC — fbc compiler for .bas sources.

Plugin ID: **`coditary/freebasic`**

## Install

```lua
reqpack { beez = { { name = "coditary/freebasic", version = "1.0.0", source = "github:Coditary/beez-freebasic" } } }
```

## Usage

```lua
configure({ { "coditary/freebasic", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[freebasic]
beez -s freebasic:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Compile BASIC sources with fbc |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/freebasic-*.ok` |

## Detection

- Markers: **/*.bas
- Entry points: `main.bas`, `src/main.bas`, or first non-test source file
- Compiles `.bas` sources with `fbc -o`.

## License

Apache License 2.0.
