# yosys

Official Yosys plugin — synthesize Verilog/SystemVerilog designs to netlists.

Plugin ID: **`coditary/yosys`**

## Install

```lua
reqpack { beez = { { name = "coditary/yosys", version = "1.0.0", source = "github:Coditary/beez-yosys" } } }
```

## Usage

```lua
configure({ { "coditary/yosys", {} } })
```

```bash
beez -p compile[yosys]
beez -s yosys:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `yosys` | `yosys -V` | Verifies Yosys binary |
| compile | `yosys` | `yosys -p "read_verilog; synth; …"` | Generates `build/yosys/bin/synth.v` |
| bundle | `yosys` | verify output | Checks synthesized netlist |
| test | `yosys` | `yosys -p "check"` | Validates Verilog hierarchy |

## Detection

- Markers: `**/*.v`, `**/*.sv`
- Top module: first non-testbench module, or `top_module` in configure()
- Output: `synth.v` (code profile), debug/statistics (debug profile)

## License

Apache License 2.0.
