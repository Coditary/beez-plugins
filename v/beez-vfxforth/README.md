# vfxforth

Official VFX Forth compiler plugin — VFX Forth with auto-detected source targets.

Plugin ID: **`coditary/vfxforth`**

## Install

```lua
reqpack { beez = { { name = "coditary/vfxforth", version = "1.0.0", source = "github:Coditary/beez-vfxforth" } } }
```

## Usage

```lua
configure({ { "coditary/vfxforth", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[vfxforth]
beez -s vfxforth:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `vforth` | Verify compiler and prepare `build/vfxforth/` |
| compile | `vforth` | Compile via `vforth <source>`. |
| bundle | verify artifacts | Checks outputs under `build/vfxforth/` |
| test | `prove -l t/` | Writes `report/test/vfxforth-*.ok` |

## Detection

- Markers: `**/*.fs`, `**/*.fth`, `**/*.4th`
- Scope: `vfxforth`
- Binary: `vforth` (override with `VFXFORTH` env or `vfxforth_binary` config)

## License

Apache License 2.0.
