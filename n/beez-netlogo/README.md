# NetLogo

NetLogo headless — model validation for auto-detected *.nlogo targets

Plugin ID: **`coditary/netlogo`**

## Install

```lua
reqpack { beez = { { name = "coditary/netlogo", version = "1.0.0", source = "github:Coditary/beez-netlogo" } } }
```

## Usage

```lua
configure({ { "coditary/netlogo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[netlogo]
beez -s coditary/netlogo:compile:code
```

## Detection

- Markers: `**/*.nlogo`
- Binary: `netlogo-headless` (override with `NETLOGO_HEADLESS` env or config)

## License

Apache License 2.0.
