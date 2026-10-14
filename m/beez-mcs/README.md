# mcs

Mono C# compiler (**mcs** / **dmcs**) — compile `*.csproj` and `**/*.cs` with auto-detected targets.

Plugin ID: **`coditary/mcs`**

Scope: **`mono`**

## Install

```lua
reqpack { beez = { { name = "coditary/mcs", version = "1.0.0", source = "github:Coditary/beez-mcs" } } }
```

## Usage

```lua
configure({ { "coditary/mcs", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[mono]
beez -s mcs:compile
```

## Compiler selection

| Framework | Binary | Use case |
|-----------|--------|----------|
| .NET 2.x / 3.x | **mcs** | Legacy Mono projects |
| .NET 4.x | **dmcs** | .NET 4+ projects (auto-detected from `TargetFrameworkVersion`) |

Override in `configure()`:

```lua
configure({ { "coditary/mcs", {
  mcs_binary = "mcs",
  dmcs_binary = "dmcs",
  references = { "packages/NUnit/lib/net45/nunit.framework.dll" },
} } })
```

## Output

Binaries are written to **`build/mcs/bin/`**.

## License

Apache License 2.0.
