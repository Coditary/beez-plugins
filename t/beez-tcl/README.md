# Tcl

Tcl interpreter — batch execution for auto-detected *.tcl targets

Plugin ID: **`coditary/tcl`**

## Install

```lua
reqpack { beez = { { name = "coditary/tcl", version = "1.0.0", source = "github:Coditary/beez-tcl" } } }
```

## Usage

```lua
configure({ { "coditary/tcl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[tcl]
beez -s coditary/tcl:compile:code
```

## Detection

- Markers: `**/*.tcl`
- Binary: `tclsh` (override with `TCLSH` env or config)

## License

Apache License 2.0.
