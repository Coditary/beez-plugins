# GNU Smalltalk

GNU Smalltalk (gst) — batch execution for auto-detected Smalltalk sources

Plugin ID: **`coditary/smalltalk`**

## Install

```lua
reqpack { beez = { { name = "coditary/smalltalk", version = "1.0.0", source = "github:Coditary/beez-smalltalk" } } }
```

## Usage

```lua
configure({ { "coditary/smalltalk", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[smalltalk]
beez -s coditary/smalltalk:compile:code
```

## Detection

- Markers: `**/*.gst`, `**/smalltalk/**/*.st`
- Binary: `gst` (override with `GST` env or config)

## License

Apache License 2.0.
