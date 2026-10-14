# amaranth

Official Amaranth HDL plugin — elaborate Python FPGA designs with auto-detection.

Plugin ID: **`coditary/amaranth`**

## Install

```lua
reqpack { beez = { { name = "coditary/amaranth", version = "1.0.0", source = "github:Coditary/beez-amaranth" } } }
```

## Usage

```lua
configure({ { "coditary/amaranth", {} } })
```

```bash
beez -p compile[amaranth]
beez -s amaranth:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `amaranth` | `pip install amaranth` | Installs Amaranth Python package |
| compile | `amaranth` | `python3 design.py` | Elaborates HDL, writes RTL to `build/amaranth/bin/` |
| bundle | `amaranth` | verify RTL | Checks elaboration stamp and Verilog output |
| test | `amaranth` | `pytest` or `py_compile` | Validates Amaranth Python sources |

## Detection

- Markers: `**/*.py` with `import amaranth` or `from amaranth import`
- Entry point: `top.py`, `main.py`, `design.py`, then first non-test Amaranth Python file, or `entry_source` in configure()
- Optional: `requirements.txt`, `pyproject.toml`

## License

Apache License 2.0.
