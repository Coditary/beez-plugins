# icestorm

Official Project IceStorm plugin — build ice40 FPGA bitstreams from Verilog and PCF constraint files.

Plugin ID: **`coditary/icestorm`**

## Install

```lua
reqpack { beez = { { name = "coditary/icestorm", version = "1.0.0", source = "github:Coditary/beez-icestorm" } } }
```

## Usage

```lua
configure({ { "coditary/icestorm", {} } })
```

```bash
beez -p compile[icestorm]
beez -s icestorm:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `icestorm` | verify yosys/nextpnr/icepack | Verifies IceStorm toolchain |
| compile | `icestorm` | yosys → nextpnr-ice40 → icepack | Generates `build/icestorm/bin/top.bin` |
| bundle | `icestorm` | verify output | Checks FPGA bitstream |
| test | `icestorm` | `yosys -p "check"` | Validates Verilog hierarchy |

## Detection

- Markers: `**/*.pcf`, `**/*.v`, `**/*.sv`
- PCF constraints: `top.pcf`, or first `*.pcf` file, or `pcf_file` in configure()
- Top module: first non-testbench module, or `top_module` in configure()
- Default FPGA: `hx8k` / `ct256` (override via `fpga_device` / `fpga_package`)

## License

Apache License 2.0.
