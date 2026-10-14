# qsharp

Official Microsoft Q# compiler — QDK to QIR with auto-detected `.qs` and `.csproj` projects.

Plugin ID: **`coditary/qsharp`**

## Install

```lua
reqpack { beez = { { name = "coditary/qsharp", version = "1.0.0", source = "github:Coditary/beez-qsharp" } } }
```

## Usage

```lua
configure({ { "coditary/qsharp", {} } })
```

```bash
beez -p compile[qsharp]
beez -s qsharp:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `qsharp` | `dotnet --version` + `qsc` | Verifies .NET SDK and Q# compiler |
| compile | `qsharp` | `dotnet build` or `qsc --emit qir` | QIR output for standalone `.qs` |
| bundle | `qsharp` | verify artifact | Checks `build/qsharp/bin/` |
| test | `qsharp` | `dotnet test` | Skipped when no test files are detected |

## Detection

- Markers: `**/*.qs`, `*.csproj`, `**/*.csproj`
- Entry points: `Program.qs`, `Main.qs`, or first root `*.qs`
- Tests: `tests/**/*.qs`, `test/**/*.qs`, `*_Test.qs`

## License

Apache License 2.0.
