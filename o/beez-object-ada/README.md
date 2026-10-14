# object-ada

**ObjectAda** (Aonix) — commercial, legacy Ada 95 OO compiler with real-time extensions. Uses `ada` / `oc` (ObjectAda) with auto-detected targets.

Plugin ID: **`coditary/object-ada`**

> **Commercial / legacy:** ObjectAda is a commercial product formerly distributed by Aonix (now Atego/PTC). Active development has ceased; this plugin targets legacy ObjectAda 7.x CLI workflows (`adareg`, `adabuild`, project files). A licensed ObjectAda installation is required — it is not available as open source.

## Install

```lua
reqpack { beez = { { name = "coditary/object-ada", version = "1.0.0", source = "github:Coditary/beez-object-ada" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/object-ada", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/object-ada", {} } })
workflows({ build = "coditary/object-ada:build" })
```

```bash
beez build
beez -p compile[object-ada]
beez -s object-ada:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `*.apr` | ObjectAda project file (preferred) |
| `**/*.adb` | Ada body sources |
| `**/*.ads` | Ada spec sources |

Build targets are resolved from a `.apr` project file, or from `main.adb`, `src/main.adb`, and `cmd/*/main.adb`. Release builds use `-O2`. Output goes to `build/object-ada/bin/`.

Test programs are detected from `tests/*.apr`, `tests/**/*.adb`, and `*_test.adb` patterns.

## Requirements

- Licensed **ObjectAda** installation (Aonix 7.x or compatible)
- `ada` and `oc` (ObjectAda CLI tools) on `PATH`

Configure binary paths if needed:

```lua
configure({
  { "coditary/object-ada", {
      ada_binary = "ada",
      oc_binary = "oc",
  }},
})
```

## License

Apache License 2.0 (plugin only — ObjectAda itself is proprietary commercial software).
