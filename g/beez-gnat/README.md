# gnat

**GNAT Ada compiler** (GCC-integrated) — `gprbuild` / `gnatmake` with auto-detected targets.

Plugin ID: **`coditary/gnat`**

## Install

```lua
reqpack { beez = { { name = "coditary/gnat", version = "1.0.0", source = "github:Coditary/beez-gnat" } } }
```

## Usage

```lua
configure({ { "coditary/gnat", {} } })
workflows({ build = "coditary/gnat:build" })
```

```bash
beez build
beez -p compile[gnat]
beez -s gnat:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `*.gpr` | GNAT project file (preferred) |
| `**/*.adb` | Ada body sources |
| `**/*.ads` | Ada spec sources |

Build targets are resolved from a `.gpr` project file, or from `main.adb`, `src/main.adb`, and `cmd/*/main.adb`. Release builds use `-O2`. Output goes to `build/gnat/bin/`.

Test programs are detected from `tests/*.gpr`, `tests/**/*.adb`, and `*_test.adb` patterns.

## Requirements

- `gnatmake`, `gprbuild`, and `gcc` (Ada) on `PATH`

## License

Apache License 2.0.
