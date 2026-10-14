# julia

Official Julia LLVM JIT compiler — `Pkg.instantiate`, `--compile=min`, auto-detected targets.

Plugin ID: **`coditary/julia`**

## Install

```lua
reqpack { beez = { { name = "coditary/julia", version = "1.0.0", source = "github:Coditary/beez-julia" } } }
```

## Usage

```lua
configure({ { "coditary/julia", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `Pkg.instantiate()` | Skipped when no `Project.toml` |
| compile | `julia --compile=min` | Precompiles package or runs entry script; output under `build/julia/bin/` |
| bundle | verify artifacts | Checks `build/julia/bin/**` |
| test | `Pkg.test()` | Uses `Pkg.test()` when `Project.toml` is present |

## Detection

- Markers: `Project.toml`, `Manifest.toml`, `**/*.jl`
- Entry points: `src/<package>.jl`, `src/main.jl`, or first `src/*.jl`

## License

Apache License 2.0.
