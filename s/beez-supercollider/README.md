# supercollider

Official supercollider compiler plugin — SuperCollider — sclang bytecode compile for **/*.scd.

Plugin ID: **`coditary/supercollider`**

## Install

```lua
reqpack { beez = { { name = "coditary/supercollider", version = "1.0.0", source = "github:Coditary/beez-supercollider" } } }
```

## Usage

```lua
configure({ { "coditary/supercollider", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[supercollider]
beez -s supercollider:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `sclang` | Prepare `build/supercollider/` |
| compile | `sclang` on sources | Writes artifacts under `build/supercollider/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/supercollider-*.ok` |

## Detection

- Markers: `**/*.scd`
- Compile SuperCollider sources to bytecode with `sclang -a`.
- Binary: `sclang` (override with `SCLANG` env or `supercollider_binary` config)

## License

Apache License 2.0.
