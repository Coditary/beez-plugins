# dxc

DirectX Shader Compiler — compile HLSL to DXIL.

Plugin ID: **`coditary/dxc`**

## Install

```lua
reqpack { beez = { { name = "coditary/dxc", version = "1.0.0", source = "github:Coditary/beez-dxc" } } }
```

## Usage

```lua
configure({ { "coditary/dxc", {} } })
workflows({ build = "coditary/dxc:build" })
```

```bash
beez -p compile[dxc]
beez -s dxc:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `dxc` | Verify `dxc` binary, prepare `build/dxc/` |
| compile | `dxc` | Compile HLSL shaders to DXIL with dxc |
| bundle | `dxc` | Verify DXIL shader artifacts |
| test | `dxc` | Verify DXIL outputs exist |

## Detection

- Markers: **/*.hlsl
- Binary: `dxc` (override with `DXC` env or `dxc_binary` config)

## License

Apache License 2.0.
