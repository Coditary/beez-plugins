# ldc

LLVM D Compiler (**LDC**) — `ldc2` build with dub and auto-detected targets.

Plugin ID: **`coditary/ldc`**

## Install

```lua
reqpack { beez = { { name = "coditary/ldc", version = "1.0.0", source = "github:Coditary/beez-ldc" } } }
```

## Usage

```lua
configure({ { "coditary/ldc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ldc]
beez -s ldc:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `dub.json` / `dub.sdl` | Dub package manifest (preferred) |
| `**/*.d` | D source files (direct `ldc2` compile) |

Release builds use `-O3 -release` via LDC. Binaries are written to `build/ldc/bin/`.

## License

Apache License 2.0.
