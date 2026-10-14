# codon

Official Codon compiler — Python to LLVM native AOT with auto-detected entry point.

Plugin ID: **`coditary/codon`**

## Install

```lua
reqpack { beez = { { name = "coditary/codon", version = "1.0.0", source = "github:Coditary/beez-codon" } } }
```

## Usage

```lua
configure({ { "coditary/codon", {} } })
```

```bash
beez -p compile[codon]
beez -s codon:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `codon` | verify `codon` binary | Writes `build/codon/.codon-setup` |
| compile | `codon` | `codon build -exe -release -o build/codon/bin/app` | Native LLVM executable |
| bundle | `codon` | verify binary | Checks `build/codon/bin/app` |
| test | `codon` | `python -m pytest` | Skipped when no test files detected |

## Detection

- Markers: `codon.yml`, `**/*.py`
- Entry points: `main.py`, `src/main.py`, `app.py`, or first non-test `*.py`
- Tests: `tests/**/*.py`, `test/**/*.py`, `test_*.py`

## License

Apache License 2.0.
