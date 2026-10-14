# unrealscript

Official unrealscript compiler plugin — UnrealScript — ucc UE1-3 compile with auto-detected **/*.uc targets.

Plugin ID: **`coditary/unrealscript`**

## Install

```lua
reqpack { beez = { { name = "coditary/unrealscript", version = "1.0.0", source = "github:Coditary/beez-unrealscript" } } }
```

## Usage

```lua
configure({ { "coditary/unrealscript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[unrealscript]
beez -s unrealscript:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `ucc` | Prepare `build/unrealscript/` |
| compile | `ucc` on sources | Writes artifacts under `build/unrealscript/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/unrealscript-*.ok` |

## Detection

- Markers: `**/*.uc`
- Compile UnrealScript packages with `ucc make` when `Default.ini` is present.
- Binary: `ucc` (override with `UCC` env or `unrealscript_binary` config)

## License

Apache License 2.0.
