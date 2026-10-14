# PostScript

Ghostscript headless PostScript rendering for auto-detected *.ps and *.eps targets

Plugin ID: **`coditary/postscript`**

## Install

```lua
reqpack { beez = { { name = "coditary/postscript", version = "1.0.0", source = "github:Coditary/beez-postscript" } } }
```

## Usage

```lua
configure({ { "coditary/postscript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[postscript]
beez -s coditary/postscript:compile:code
```

## Detection

- Markers: `**/*.ps`, `**/*.eps`
- Binary: `gs` (override with `GS` env or config)

## License

Apache License 2.0.
