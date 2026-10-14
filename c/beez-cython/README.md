# cython

Cython compiler — transpiles Python to C extensions and native modules via `cython` and `python setup.py build_ext`.

Plugin ID: **`coditary/cython`**

## Install

```lua
reqpack { beez = { { name = "coditary/cython", version = "1.0.0", source = "github:Coditary/beez-cython" } } }
```

## Usage

```lua
configure({ { "coditary/cython", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p setup[cython]
beez -p compile[cython]
beez -s cython:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `pip install cython setuptools wheel` | Optional `requirements.txt` |
| compile | `python setup.py build_ext` | Output under `build/cython/lib/` |
| bundle | verify artifacts | Checks `build/cython/lib/**` for `.so`/`.pyd`/`.c` |
| test | `python -m pytest` | Skipped when no `setup.py`/`pyproject.toml` |

## Detection

- Markers: `setup.py`, `pyproject.toml`, `**/*.pyx`, `**/*.py`
- Build: `setup.py` → `build_ext`; `pyproject.toml` → `pip install .`; `.pyx` only → `cython -3`

## Scope

All steps use scope **`cython`** (release and debug profiles).

## License

Apache License 2.0.
