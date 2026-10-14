# sdc

**Saarland D Compiler (SDC)** — experimental D compiler written in D. This plugin builds D projects with `sdc` / `dub` and auto-detected targets.

> **Experimental:** SDC is an experimental compiler. Language coverage, dub integration, and build behavior may differ from dmd/LDC/GDC. Use for experimentation and early adoption only.

Plugin ID: **`coditary/sdc`**

## Install

```lua
reqpack { beez = { { name = "coditary/sdc", version = "1.0.0", source = "github:Coditary/beez-sdc" } } }
```

## Usage

```lua
configure({ { "coditary/sdc", {} } })
```

```bash
beez -p setup[sdc]
beez -p compile[sdc]
beez -p bundle[sdc]
beez -p test[sdc]
```

## Detection

| Marker | Meaning |
|--------|---------|
| `dub.json` / `dub.sdl` | Dub project — `dub fetch`, `dub build --compiler=sdc`, `dub test` |
| `**/*.d` | Plain D sources — compiled directly with `sdc` |

Binaries are written to `build/sdc/bin/`.

## License

Apache License 2.0.
