# gccgo

GCC frontend for Go — `go build -compiler=gccgo` with auto-detected targets.

Plugin ID: **`coditary/gccgo`**

## Install

```lua
reqpack { beez = { { name = "coditary/gccgo", version = "1.0.0", source = "github:Coditary/beez-gccgo" } } }
```

## Usage

```lua
configure({ { "coditary/gccgo", {} } })
workflows({ build = "coditary/gccgo:build" })
```

```bash
beez build
beez -s gccgo:compile
beez -p compile[gccgo]
```

## Defaults

- `go build -compiler=gccgo -gccgoflags=-O2`
- `CGO_ENABLED=1`
- Scope: `gccgo` (does not conflict with `coditary/go`)

## License

Apache License 2.0.
