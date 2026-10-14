# Maxima

Maxima computer algebra — batch execution for auto-detected *.mac and *.wxm targets

Plugin ID: **`coditary/maxima`**

## Install

```lua
reqpack { beez = { { name = "coditary/maxima", version = "1.0.0", source = "github:Coditary/beez-maxima" } } }
```

## Usage

```lua
configure({ { "coditary/maxima", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[maxima]
beez -s coditary/maxima:compile:code
```

## Detection

- Markers: `**/*.mac`, `**/*.wxm`
- Binary: `maxima` (override with `MAXIMA` env or config)

## License

Apache License 2.0.
