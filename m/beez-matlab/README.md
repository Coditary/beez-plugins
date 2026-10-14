# matlab

Official MATLAB compiler plugin — MATLAB Coder mcc — compile .m sources to native binaries.

Plugin ID: **`coditary/matlab`**

## Install

```lua
reqpack { beez = { { name = "coditary/matlab", version = "1.0.0", source = "github:Coditary/beez-matlab" } } }
```

## Usage

```lua
configure({ { "coditary/matlab", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[matlab]
beez -s coditary/matlab:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `matlab` | Verify toolchain, create `build/matlab/.matlab-setup` |
| compile | `matlab` | Compile sources to `build/matlab/` |
| bundle | `matlab` | Verify compile artifacts |
| test | `matlab` | Writes `report/test/matlab-*.ok` |

## Detection

- Markers: **/*.m
- Entry points: `main.m`, `src/main.m`, or first non-test `*.m`

## License

Apache License 2.0.
