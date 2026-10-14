# newLISP

newLISP interpreter — load validation for auto-detected *.lsp targets

Plugin ID: **`coditary/newlisp`**

## Install

```lua
reqpack { beez = { { name = "coditary/newlisp", version = "1.0.0", source = "github:Coditary/beez-newlisp" } } }
```

## Usage

```lua
configure({ { "coditary/newlisp", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[newlisp]
beez -s coditary/newlisp:compile:code
```

## Detection

- Markers: `**/*.lsp`
- Binary: `newlisp` (override with `NEWLISP` env or config)

## License

Apache License 2.0.
