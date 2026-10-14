# tmt-pascal

TMT Pascal (commercial 32/64-bit Pascal compiler) — compile `*.tmt`, `*.dpr`, and `*.pas` with auto-detected targets.

Plugin ID: **`coditary/tmt-pascal`**

## Install

```lua
reqpack { beez = { { name = "coditary/tmt-pascal", version = "1.0.0", source = "github:Coditary/beez-tmt-pascal" } } }
```

## Usage

```lua
configure({ { "coditary/tmt-pascal", {} } })
```

```bash
beez -p setup[tmt-pascal]
beez -p compile[tmt-pascal]
beez -p bundle[tmt-pascal]
beez -p test[tmt-pascal]
```

Build artifacts are written to `build/tmt-pascal/bin/`.

## Toolchain

| Binary | Role |
|--------|------|
| `tmtpc` | 32-bit command-line compiler (default) |
| `tmt` | 64-bit command-line compiler |

Use `target_bits = 64` or set `tmt_pascal_binary = "tmt"` in plugin config for 64-bit builds.

## Detection

| Marker | Role |
|--------|------|
| `*.tmt` | TMT Pascal project file (primary) |
| `*.dpr` | Delphi-style program |
| `*.pas` | Fallback single-unit program |

Release builds use `-$OPT+` optimization.

## License

Apache License 2.0.
