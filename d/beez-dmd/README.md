# dmd

Digital Mars D reference compiler (**dmd**) — `dmd` / `dub` build with auto-detected targets.

Plugin ID: **`coditary/dmd`**

## Install

```lua
reqpack { beez = { { name = "coditary/dmd", version = "1.0.0", source = "github:Coditary/beez-dmd" } } }
```

## Usage

```lua
configure({ { "coditary/dmd", {} } })
```

```bash
beez -p setup[dmd]
beez -p compile[dmd]
beez -p bundle[dmd]
beez -p test[dmd]
```

## Detection

| Marker | Meaning |
|--------|---------|
| `dub.json` / `dub.sdl` | Dub project — `dub fetch`, `dub build --compiler=dmd`, `dub test` |
| `**/*.d` | Plain D sources — compiled directly with `dmd` |

Binaries are written to `build/dmd/bin/`.

## License

Apache License 2.0.
