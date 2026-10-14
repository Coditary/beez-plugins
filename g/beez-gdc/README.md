# gdc

GNU D Compiler (**gdc**) — GCC backend for D with auto-detected dub and plain source targets.

Plugin ID: **`coditary/gdc`**

## Install

```lua
reqpack { beez = { { name = "coditary/gdc", version = "1.0.0", source = "github:Coditary/beez-gdc" } } }
```

## Usage

```lua
configure({ { "coditary/gdc", {} } })
workflows({ build = "coditary/gdc:build" })
```

```bash
beez build
beez -s coditary/gdc:compile:code
beez -p compile[gdc]
```

## Detection

| Marker | Meaning |
|--------|---------|
| `dub.json` / `dub.sdl` | Dub package — `dub fetch` / `dub build --compiler=gdc` |
| `**/*.d` | Plain D sources — direct `gdc` compile |

Binaries are written to `build/gdc/bin/`.

## Defaults

- Release: `gdc -O2` / `dub build --compiler=gdc --build=release`
- Debug: `gdc -g` / `dub build --compiler=gdc --build=debug`
- Scope: `gdc`

## License

Apache License 2.0.
