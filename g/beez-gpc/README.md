# gpc

**GNU Pascal (GPC)** — historical Pascal compiler with auto-detected `.pas` / `.p` sources.

Plugin ID: **`coditary/gpc`**

> **Legacy notice:** GPC (GNU Pascal Compiler) is a discontinued, historical compiler.
> Last upstream activity was in the early 2000s. Modern Pascal projects should prefer
> [Free Pascal (FPC)](https://www.freepascal.org/) or [Delphi](https://www.embarcadero.com/products/delphi).
> This plugin exists for maintaining legacy codebases and historical builds only.

## Install

```lua
reqpack { beez = { { name = "coditary/gpc", version = "1.0.0", source = "github:Coditary/beez-gpc" } } }
```

## Usage

```lua
configure({ { "coditary/gpc", {} } })
workflows({ build = "coditary/gpc:build" })
```

```bash
beez build
beez -p compile[gpc]
beez -s gpc:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.pas` | Pascal source files |
| `**/*.p` | Alternate Pascal extension |

Build targets are resolved from `main.pas`, `program.pas`, `src/main.pas`, `cmd/*/main.pas`, or all non-test sources. Output goes to `build/gpc/bin/`.

Test programs are detected from `tests/**`, `*test*`, and `*_test` patterns.

## Requirements

- `gpc` on `PATH` (GNU Pascal Compiler)

## License

Apache License 2.0.
