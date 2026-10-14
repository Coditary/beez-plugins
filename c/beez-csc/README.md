# csc

Roslyn C# compiler (**Microsoft .NET Compiler Platform**) — `dotnet build` with auto-detected projects.

Plugin ID: **`coditary/csc`**

## Install

```lua
reqpack { beez = { { name = "coditary/csc", version = "1.0.0", source = "github:Coditary/beez-csc" } } }
```

## Usage

```lua
configure({ { "coditary/csc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Detection

| Marker | Toolchain |
|--------|-----------|
| `*.sln`, `*.csproj` | `dotnet restore` / `dotnet build` / `dotnet test` |
| `**/*.cs` (no project) | `csc` standalone compile |

Build output: `build/csc/`

## License

Apache License 2.0.
