# qbasic

QuickBASIC/qb64 — qb64 compiler for .bas sources.

Plugin ID: **`coditary/qbasic`**

## Install

```lua
reqpack { beez = { { name = "coditary/qbasic", version = "1.0.0", source = "github:Coditary/beez-qbasic" } } }
```

## Usage

```lua
configure({ { "coditary/qbasic", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[qbasic]
beez -s qbasic:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Compile BASIC sources with qb64 |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/qbasic-*.ok` |

## Detection

- Markers: **/*.bas
- Entry points: `main.bas`, `src/main.bas`, or first non-test source file
- Compiles `.bas` sources with `qb64 -c`.

## License

Apache License 2.0.
