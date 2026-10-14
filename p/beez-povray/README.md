# POV-Ray

POV-Ray SDL raytracing — headless render for auto-detected *.pov scenes

Plugin ID: **`coditary/povray`**

## Install

```lua
reqpack { beez = { { name = "coditary/povray", version = "1.0.0", source = "github:Coditary/beez-povray" } } }
```

## Usage

```lua
configure({ { "coditary/povray", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[povray]
beez -s coditary/povray:compile:code
```

## Detection

- Markers: `**/*.pov`
- Binary: `povray` (override with `POVRAY` env or config)

## License

Apache License 2.0.
