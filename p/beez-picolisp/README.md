# PicoLisp

PicoLisp — pil batch execution for auto-detected *.l targets

Plugin ID: **`coditary/picolisp`**

## Install

```lua
reqpack { beez = { { name = "coditary/picolisp", version = "1.0.0", source = "github:Coditary/beez-picolisp" } } }
```

## Usage

```lua
configure({ { "coditary/picolisp", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[picolisp]
beez -s coditary/picolisp:compile:code
```

## Detection

- Markers: `**/*.l`
- Binary: `pil` (override with `PIL` env or config)

## License

Apache License 2.0.
