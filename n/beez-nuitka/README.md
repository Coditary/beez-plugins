# nuitka

Official Nuitka compiler — `python -m nuitka --standalone` with auto-detected Python entry points.

Plugin ID: **`coditary/nuitka`**

## Install

```lua
reqpack { beez = { { name = "coditary/nuitka", version = "1.0.0", source = "github:Coditary/beez-nuitka" } } }
```

## Usage

```lua
configure({ { "coditary/nuitka", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[nuitka]
beez -s nuitka:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `pip install -e .` + `pip install nuitka` | Uses `requirements.txt` when no `pyproject.toml` |
| compile | `python -m nuitka --standalone` | Output under `build/nuitka/bin/` |
| bundle | verify standalone binaries | Checks `build/nuitka/bin/*.dist/` |
| test | `python -m pytest` | Writes `report/test/nuitka-*.ok` |

## Detection

- Markers: `pyproject.toml`, `**/*.py`
- Entry points: `main.py`, `app.py`, `src/main.py`, or first `src/*/__main__.py`

## License

Apache License 2.0.
