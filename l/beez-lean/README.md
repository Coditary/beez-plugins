# lean

Lean 4 theorem prover — lake build with C code extraction.

Plugin ID: **`coditary/lean`**

## Install

```lua
reqpack { beez = { { name = "coditary/lean", version = "1.0.0", source = "github:Coditary/beez-lean" } } }
```

## Usage

```lua
configure({ { "coditary/lean", {} } })
workflows({ build = "coditary/lean:build" })
```

```bash
beez -p compile[lean]
beez -s lean:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `lean` | Verify `lake` binary, prepare `build/lean/` |
| compile | `lean` | Build Lean 4 project with lake build |
| bundle | `lean` | Verify Lean build artifacts in .lake/build |
| test | `lean` | Run Lean tests with lake test |

## Detection

- Markers: lakefile.lean, **/lakefile.lean, **/*.lean
- Binary: `lake` (override with `LAKE` env or `lake_binary` config)

## License

Apache License 2.0.
