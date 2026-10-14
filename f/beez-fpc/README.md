# fpc

Free Pascal Compiler (**FPC**) — compile `*.dpr`, `*.lpi`, and `*.pas` with auto-detected targets.

Plugin ID: **`coditary/fpc`**

## Install

```lua
reqpack { beez = { { name = "coditary/fpc", version = "1.0.0", source = "github:Coditary/beez-fpc" } } }
```

## Usage

```lua
configure({ { "coditary/fpc", {} } })
```

```bash
beez -p setup[fpc]
beez -p compile[fpc]
beez -p bundle[fpc]
beez -p test[fpc]
```

Build artifacts are written to `build/fpc/bin/`.

## Detection

| Marker | Role |
|--------|------|
| `*.dpr` | Delphi/FPC program (primary) |
| `*.lpi` + `*.lpr` | Lazarus project |
| `*.pas` | Fallback single-unit program |

Release builds use `-O2` optimization.

## License

Apache License 2.0.
