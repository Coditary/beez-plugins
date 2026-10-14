# gdscript

Godot GDScript headless — `godot --headless` with auto-detected `*.gd` and `project.godot`.

Plugin ID: **`coditary/gdscript`**

## Install

```lua
reqpack { beez = { { name = "coditary/gdscript", version = "1.0.0", source = "github:Coditary/beez-gdscript" } } }
```

## Usage

```lua
configure({ { "coditary/gdscript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[gdscript]
beez -s coditary/gdscript:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `godot --headless --import` | Verifies `godot`; imports when `project.godot` exists |
| compile | `godot --headless --quit-after 1` | Validates Godot project and GDScript |
| bundle | verify compile stamp | Checks `build/gdscript/.gdscript-compile-*` |
| test | `godot --headless --script` | Runs `main.gd` or first entry |

## Detection

- Markers: `project.godot`, `**/*.gd`
- Entry points: `main.gd`, `Main.gd`, or first non-test script
- Binary: `godot` (override with `GODOT` env or `godot_binary` config)
- Scope: `gdscript`

## License

Apache License 2.0.
