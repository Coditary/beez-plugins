# go

Official Go compiler (**gc**) — `go build` with auto-detected targets.

Plugin ID: **`coditary/go`**

## Install

```lua
reqpack { beez = { { name = "coditary/go", version = "1.0.0", source = "github:Coditary/beez-go" } } }
```

## Usage

```lua
configure({ { "coditary/go", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Other Go compilers

| Plugin | Compiler | Use case |
|--------|----------|----------|
| `coditary/go` | **gc** | Standard (this plugin) |
| `coditary/gccgo` | **gccgo** | GCC optimizations, niche architectures |
| `coditary/tinygo` | **TinyGo** | Wasm, microcontrollers, embedded |

Load only the compiler plugin you need.

## License

Apache License 2.0.
