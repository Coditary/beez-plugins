# a68g

ALGOL 68G — a68g compiler for .a68 sources.

Plugin ID: **`coditary/a68g`**

## Install

```lua
reqpack { beez = { { name = "coditary/a68g", version = "1.0.0", source = "github:Coditary/beez-a68g" } } }
```

## Usage

```lua
configure({ { "coditary/a68g", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[a68g]
beez -s a68g:compile
```

## Steps

| Phase | Step | Notes |
|-------|------|-------|
| setup | `configure:setup` / `configure:debug` | Toolchain verification |
| compile | `compile:code` / `compile:debug` | Compile ALGOL 68 sources with a68g |
| bundle | `bundle:code` / `bundle:debug` | Verify build artifacts |
| test | `test:unit` / `test:debug` | Writes `report/test/a68g-*.ok` |

## Detection

- Markers: **/*.a68
- Entry points: `main.a68`, `src/main.a68`, or first non-test source file
- Compiles `.a68` sources with `a68g -o`.

## License

Apache License 2.0.
