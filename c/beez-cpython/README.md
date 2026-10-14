# cpython

Official CPython compiler — `python -m compileall` with auto-detected targets (bytecode `.pyc`).

Plugin ID: **`coditary/cpython`**

## Install

```lua
reqpack { beez = { { name = "coditary/cpython", version = "1.0.0", source = "github:Coditary/beez-cpython" } } }
```

## Usage

```lua
configure({ { "coditary/cpython", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `pip install .` / `pip install -r requirements.txt` | Skipped when no manifest |
| compile | `python -m compileall -b -d build/cpython` | Output under `build/cpython/` |
| bundle | verify bytecode | Checks `build/cpython/**/*.pyc` |
| test | `python -m pytest` | Writes `report/test/cpython-*.ok` |

## Detection

- Markers: `pyproject.toml`, `setup.py`, `requirements.txt`, `**/*.py`
- Entry points: `main.py`, `src/main.py`, or first non-test `*.py`
- Binary: `python3` (override with `PYTHON` env or `python_binary` config)

## License

Apache License 2.0.
