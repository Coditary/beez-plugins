# processing

Official Processing compiler plugin — export sketches with processing-java, auto-detected **/*.pde.

Plugin ID: **`coditary/processing`**

## Install

```lua
reqpack { beez = { { name = "coditary/processing", version = "1.0.0", source = "github:Coditary/beez-processing" } } }
```

## Usage

```lua
configure({ { "coditary/processing", {} } })
workflows({ build = "coditary/processing:build" })
```

```bash
beez build
beez -p compile[processing]
beez -s processing:compile
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `processing` | Verify `processing-java` toolchain |
| compile | `processing` | Compile detected sources |
| bundle | `processing` | Verify build artifacts under `build/processing/bin/` |
| test | `processing` | Run primary output or write test stamp |

## Detection

- Markers: `**/*.pde`
- Compile targets: auto-detected entry points via `ctx.glob`
- Binary: `processing-java` (override with `PROCESSING_JAVA` env or `processing_java_binary` config)

## License

Apache License 2.0.
