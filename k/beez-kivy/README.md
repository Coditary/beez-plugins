# kivy

Official Kivy plugin — validate `.kv` UI files and compile Python sources with headless Kivy (`KIVY_HEADLESS=1`).

Plugin ID: **`coditary/kivy`**

## Requirements

- Python 3 with `pip`
- Kivy (installed automatically via `pip install kivy` in the setup step)

## Install

```lua
reqpack { beez = { { name = "coditary/kivy", version = "1.0.0", source = "github:Coditary/beez-kivy" } } }
```

## Usage

```lua
configure({ { "coditary/kivy", {} } })
workflows({ build = "coditary/kivy:build" })
```

```bash
beez build
beez -p compile[kivy]
beez -s kivy:compile
```

## Headless mode

All compile and test steps run with `KIVY_HEADLESS=1` by default so CI builds do not require a display server. Override via environment or config:

| Variable | Default | Purpose |
|----------|---------|---------|
| `KIVY_HEADLESS` | `1` | Disable Kivy window creation |
| `PYTHON` | `python3` | Python interpreter |
| `PIP` | `pip3` | pip for dependency install |

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `kivy` | `pip install kivy` (+ project deps) |
| compile | `kivy` | Validate `.kv` via `Builder.load_file`, compileall Python |
| bundle | `kivy` | Verify `.kv.ok` stamps and `.pyc` artifacts |
| test | `kivy` | Run pytest with `KIVY_HEADLESS=1` |

## Detection

- Markers: `**/*.kv`, `**/*.py`, `pyproject.toml`, `requirements.txt`
- Entry points: `main.kv`, `main.py`, or first non-test source via `ctx.glob`

## License

Apache License 2.0.
