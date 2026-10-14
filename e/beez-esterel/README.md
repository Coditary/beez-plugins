# esterel

Esterel v7 synchronous reactive language compiler to C.

Plugin ID: **`coditary/esterel`**

## Install

```lua
reqpack { beez = { { name = "coditary/esterel", version = "1.0.0", source = "github:Coditary/beez-esterel" } } }
```

## Usage

```lua
configure({ { "coditary/esterel", {} } })
workflows({ build = "coditary/esterel:build" })
```

```bash
beez -p compile[esterel]
beez -s esterel:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `esterel` | Verify `esterel` binary, prepare `build/esterel/` |
| compile | `esterel` | Compile Esterel .strl sources to C with esterel |
| bundle | `esterel` | Verify Esterel C output artifacts |
| test | `esterel` | Run Esterel tests in t/ with prove |

## Detection

- Markers: **/*.strl
- Binary: `esterel` (override with `ESTEREL` env or `esterel_binary` config)

## License

Apache License 2.0.
