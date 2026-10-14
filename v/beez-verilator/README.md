# verilator

Official Verilator plugin — compile Verilog/SystemVerilog to a C++ simulation binary.

Plugin ID: **`coditary/verilator`**

## Install

```lua
reqpack { beez = { { name = "coditary/verilator", version = "1.0.0", source = "github:Coditary/beez-verilator" } } }
```

## Usage

```lua
configure({ { "coditary/verilator", {} } })
```

```bash
beez -p compile[verilator]
beez -s verilator:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `verilator` | `verilator --version` | Verifies Verilator binary |
| compile | `verilator` | `verilator --binary …` | Builds `build/verilator/bin/app` |
| bundle | `verilator` | verify binary | Checks `build/verilator/bin/app` |
| test | `verilator` | run simulation binary | Skipped when no testbench is detected |

## Detection

- Markers: `**/*.v`, `**/*.sv`
- Top module: first non-testbench file basename, or `top_module` in configure()
- Testbenches: `*_tb.v`, `tb_*.v`, `test_*.v`

## License

Apache License 2.0.
