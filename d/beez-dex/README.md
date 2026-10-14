# dex

Official Google Dex ML compiler — Dex to LLVM IR with auto-detected `.dex` programs.

Plugin ID: **`coditary/dex`**

## Install

```lua
reqpack { beez = { { name = "coditary/dex", version = "1.0.0", source = "github:Coditary/beez-dex" } } }
```

## Usage

```lua
configure({ { "coditary/dex", {} } })
```

```bash
beez -p compile[dex]
beez -s dex:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `dex` | `python -c "import dex; import jax"` | Verifies Dex/JAX environment |
| compile | `dex` | Dex→LLVM | Compiles `.dex` to LLVM IR |
| bundle | `dex` | verify output | Checks `build/dex/bin/app.ll` |
| test | `dex` | `pytest` | Skipped when no test files are detected |

## Detection

- Markers: `**/*.dex`
- Entry points: `main.dex`, `program.dex`, or first root `*.dex`
- Tests: `tests/**/*.dex`, `tests/**/*.py`, `*_test.dex`

## License

Apache License 2.0.
