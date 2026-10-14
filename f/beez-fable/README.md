# fable

Fable transpiler — **F# to JavaScript/TypeScript** via `dotnet fable` with auto-detected projects.

Plugin ID: **`coditary/fable`**

## Install

```lua
reqpack { beez = { { name = "coditary/fable", version = "1.0.0", source = "github:Coditary/beez-fable" } } }
```

## Usage

```lua
configure({ { "coditary/fable", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[fable]
beez -s fable:compile
```

## Detection

| Marker | Toolchain |
|--------|-----------|
| `*.sln`, `*.fsproj` | `dotnet restore` / `dotnet fable` / `dotnet test` |

Build output: `build/fable/`

## License

Apache License 2.0.
