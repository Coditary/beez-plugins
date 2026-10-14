# PowerShell

PowerShell Core (pwsh) — script parse validation for auto-detected *.ps1 targets

Plugin ID: **`coditary/pwsh`**

## Install

```lua
reqpack { beez = { { name = "coditary/pwsh", version = "1.0.0", source = "github:Coditary/beez-pwsh" } } }
```

## Usage

```lua
configure({ { "coditary/pwsh", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[pwsh]
beez -s coditary/pwsh:compile:code
```

## Detection

- Markers: `**/*.ps1`
- Binary: `pwsh` (override with `PWSH` env or config)

## License

Apache License 2.0.
