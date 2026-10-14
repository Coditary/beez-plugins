# futhark

Official Futhark GPU compiler — C/CUDA/OpenCL backends with auto-detected `.fut` programs.

Plugin ID: **`coditary/futhark`**

## Install

```lua
reqpack { beez = { { name = "coditary/futhark", version = "1.0.0", source = "github:Coditary/beez-futhark" } } }
```

## Usage

```lua
configure({ { "coditary/futhark", {} } })
```

```bash
beez -p compile[futhark]
beez -s futhark:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `futhark` | `futhark --version` | Verifies Futhark compiler |
| compile | `futhark` | `futhark c` / `futhark opencl` | C backend (release), OpenCL (debug) |
| bundle | `futhark` | verify binary | Checks `build/futhark/bin/app` |
| test | `futhark` | `futhark test` | Skipped when no test files are detected |

## Detection

- Markers: `**/*.fut`
- Entry points: `main.fut`, `program.fut`, or first root `*.fut`
- Tests: `tests/**/*.fut`, `test/**/*.fut`, `*_test.fut`

## License

Apache License 2.0.
