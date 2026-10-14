# ghdl

Official GHDL VHDL compiler plugin — analyze, elaborate, and build auto-detected VHDL designs.

Plugin ID: **`coditary/ghdl`**

## Install

```lua
reqpack { beez = { { name = "coditary/ghdl", version = "1.0.0", source = "github:Coditary/beez-ghdl" } } }
```

## Usage

```lua
configure({ { "coditary/ghdl", {} } })
```

```bash
beez -p compile[ghdl]
beez -s ghdl:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ghdl` | `ghdl --version` | Verifies GHDL binary |
| compile | `ghdl` | `ghdl -a … && ghdl -e top` | Builds `build/ghdl/bin/app` |
| bundle | `ghdl` | verify binary | Checks `build/ghdl/bin/app` |
| test | `ghdl` | `ghdl -r top` | Skipped when no testbench is detected |

## Detection

- Markers: `**/*.vhdl`, `**/*.vhd`
- Top entity: first non-testbench file basename, or `top_entity` in configure()
- Testbenches: `*_tb.vhd`, `tb_*.vhd`, `test_*.vhd`

## License

Apache License 2.0.
