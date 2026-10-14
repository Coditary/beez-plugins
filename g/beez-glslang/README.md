# glslang

glslangValidator — compile GLSL shaders to SPIR-V.

Plugin ID: **`coditary/glslang`**

## Install

```lua
reqpack { beez = { { name = "coditary/glslang", version = "1.0.0", source = "github:Coditary/beez-glslang" } } }
```

## Usage

```lua
configure({ { "coditary/glslang", {} } })
workflows({ build = "coditary/glslang:build" })
```

```bash
beez -p compile[glslang]
beez -s glslang:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `glslang` | Verify `glslangValidator` binary, prepare `build/glslang/` |
| compile | `glslang` | Compile GLSL shaders to SPIR-V with glslangValidator -V |
| bundle | `glslang` | Verify SPIR-V shader artifacts |
| test | `glslang` | Verify SPIR-V outputs exist |

## Detection

- Markers: **/*.glsl, **/*.vert, **/*.frag
- Binary: `glslangValidator` (override with `GLSLANG_VALIDATOR` env or `glslang_binary` config)

## License

Apache License 2.0.
