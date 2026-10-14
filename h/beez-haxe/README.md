# haxe

Official Haxe compiler plugin — haxe with auto-detected source targets.

Plugin ID: **`coditary/haxe`**

## Install

```lua
reqpack { beez = { { name = "coditary/haxe", version = "1.0.0", source = "github:Coditary/beez-haxe" } } }
```

## Usage

```lua
configure({ { "coditary/haxe", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[haxe]
beez -s haxe:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `haxe` | Verify compiler and prepare `build/haxe/` |
| compile | `haxe` | Compile via `haxe build.hxml`, `haxe project.xml`, or per-main `.hx` source. |
| bundle | verify artifacts | Checks outputs under `build/haxe/` |
| test | `prove -l t/` | Writes `report/test/haxe-*.ok` |

## Detection

- Markers: `**/*.hx`, `project.xml`, `**/project.xml`
- Scope: `haxe`
- Binary: `haxe` (override with `HAXE` env or `haxe_binary` config)

## License

Apache License 2.0.
