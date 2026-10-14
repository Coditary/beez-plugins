# skidl

Official SKiDL plugin — Python PCB netlist compiler generating KiCad netlists.

Plugin ID: **`coditary/skidl`**

## Install

```lua
reqpack { beez = { { name = "coditary/skidl", version = "1.0.0", source = "github:Coditary/beez-skidl" } } }
```

## Usage

```lua
configure({ { "coditary/skidl", {} } })
```

```bash
beez -p compile[skidl]
beez -s skidl:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `skidl` | `pip install skidl` | Installs SKiDL and optional requirements |
| compile | `skidl` | `python circuit_skidl.py` | Generates `build/skidl/netlist.net` |
| bundle | `skidl` | verify netlist | Checks KiCad netlist output |
| test | `skidl` | `pytest` | Validates netlist generation |

## Detection

- Markers: `**/*_skidl.py`, `**/*.py` with SKiDL imports
- Entry point: first `*_skidl.py`, then first `.py` importing `skidl`
- Output: `build/skidl/netlist.net`

## License

Apache License 2.0.
