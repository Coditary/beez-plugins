# Vim script

Vim script — batch validation via vim -e -s for auto-detected *.vim targets

Plugin ID: **`coditary/vimscript`**

## Install

```lua
reqpack { beez = { { name = "coditary/vimscript", version = "1.0.0", source = "github:Coditary/beez-vimscript" } } }
```

## Usage

```lua
configure({ { "coditary/vimscript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[vimscript]
beez -s coditary/vimscript:compile:code
```

## Detection

- Markers: `**/*.vim`
- Binary: `vim` (override with `VIM` env or config)

## License

Apache License 2.0.
