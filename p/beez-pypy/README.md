# pypy

Official PyPy JIT Python implementation — `pypy3 -m compileall` with auto-detected targets.

Plugin ID: **`coditary/pypy`**

## Install

```lua
reqpack { beez = { { name = "coditary/pypy", version = "1.0.0", source = "github:Coditary/beez-pypy" } } }
```

## Usage

```lua
configure({ { "coditary/pypy", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[pypy]
beez -s pypy:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `pypy3 -m pip install` | From `requirements.txt` and/or `pyproject.toml` |
| compile | `pypy3 -m compileall -b -d build/pypy` | Bytecode under `build/pypy/` |
| bundle | verify `.pyc` artifacts | Checks `build/pypy/**` |
| test | `pypy3 -m pytest` | Runs project tests with PyPy |

## Detection

- Markers: `pyproject.toml`, `requirements.txt`, `**/*.py`
- Entry points: `main.py`, `src/main.py`, `run.py`, or first non-test `*.py`
- Binary: `pypy3` with fallback to `pypy`

## License

Apache License 2.0.
