# sphinx-doc

Official Python Sphinx documentation plugin — `sphinx-build` reST with auto-detected `conf.py`.

Plugin ID: **`coditary/sphinx-doc`**

## Install

```lua
reqpack { beez = { { name = "coditary/sphinx-doc", version = "1.0.0", source = "github:Coditary/beez-sphinx-doc" } } }
```

## Usage

```lua
configure({ { "coditary/sphinx-doc", {} } })
```

```bash
beez -p compile[sphinx-doc]
beez -s sphinx-doc:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `sphinx-doc` | `sphinx-build --version` | Verifies Sphinx binary |
| compile | `sphinx-doc` | `sphinx-build -b html …` | Builds `build/sphinx-doc/html/index.html` |
| bundle | `sphinx-doc` | verify output | Checks generated HTML index |
| test | `sphinx-doc` | `sphinx-build -b linkcheck …` | Validates documentation links |

## Detection

- Markers: `conf.py`, `**/*.rst`
- Source dir: directory containing `conf.py`
- Tests: `tests/**/*.rst`, `test/**/*.rst`, `*_test.rst`

## License

Apache License 2.0.
