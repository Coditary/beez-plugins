# austral

Official Austral compiler — linear types to C with auto-detected `Module.au` entry point.

Plugin ID: **`coditary/austral`**

## Install

```lua
reqpack { beez = { { name = "coditary/austral", version = "1.0.0", source = "github:Coditary/beez-austral" } } }
```

## Usage

```lua
configure({ { "coditary/austral", {} } })
```

```bash
beez -p compile[austral]
beez -s austral:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `austral` | `austral --version` | Verifies Austral compiler binary |
| compile | `austral` | `austral compile Module.au` + `gcc` | Emits C then links native binary |
| bundle | `austral` | verify binary | Checks `build/austral/bin/app` |
| test | `austral` | compile test modules | Skipped when no test files are detected |

## Detection

- Markers: `Module.au`, `**/*.au`
- Entry: `Module.au` or `main.au` (shallowest match)
- Tests: `test/**/*.au`, `tests/**/*.au`, `*_test.au`

## License

Apache License 2.0.
