# xojo

Official xojo compiler plugin — Xojo LLVM native — xojo build with **/*.xojo_code and *.xojo_project.

Plugin ID: **`coditary/xojo`**

## Install

```lua
reqpack { beez = { { name = "coditary/xojo", version = "1.0.0", source = "github:Coditary/beez-xojo" } } }
```

## Usage

```lua
configure({ { "coditary/xojo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[xojo]
beez -s xojo:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `xojo` | Prepare `build/xojo/` |
| compile | `xojo` on sources | Writes artifacts under `build/xojo/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/xojo-*.ok` |

## Detection

- Markers: `**/*.xojo_code`, `*.xojo_project`, `**/*.xojo_project`
- Build Xojo projects with `xojo --build` when a `.xojo_project` manifest is found.
- Binary: `xojo` (override with `XOJO` env or `xojo_binary` config)

## License

Apache License 2.0.
