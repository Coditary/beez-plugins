# halide

Halide AOT/JIT image processing pipeline generator.

Plugin ID: **`coditary/halide`**

## Install

```lua
reqpack { beez = { { name = "coditary/halide", version = "1.0.0", source = "github:Coditary/beez-halide" } } }
```

## Usage

```lua
configure({ { "coditary/halide", {} } })
workflows({ build = "coditary/halide:build" })
```

```bash
beez -p compile[halide]
beez -s halide:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `halide` | Verify `cxx` binary, prepare `build/halide/` |
| compile | `halide` | Build Halide generator and compile AOT pipeline |
| bundle | `halide` | Verify Halide static library artifacts |
| test | `halide` | Verify Halide build outputs exist |

## Detection

- Markers: **/*.generator.cpp, **/pipeline.cpp
- Binary: `cxx` (override with `CXX` env or `cxx_binary` config)

## License

Apache License 2.0.
