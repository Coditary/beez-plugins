# Z shell

Zsh shell — syntax check for auto-detected *.zsh targets

Plugin ID: **`coditary/zsh`**

## Install

```lua
reqpack { beez = { { name = "coditary/zsh", version = "1.0.0", source = "github:Coditary/beez-zsh" } } }
```

## Usage

```lua
configure({ { "coditary/zsh", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[zsh]
beez -s coditary/zsh:compile:code
```

## Detection

- Markers: `**/*.zsh`
- Binary: `zsh` (override with `ZSH` env or config)

## License

Apache License 2.0.
