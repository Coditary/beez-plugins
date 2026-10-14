# peachpie

Peachpie PHP-to-.NET IL compiler — `dotnet build` with auto-detected Peachpie projects.

Plugin ID: **`coditary/peachpie`**

## Install

```lua
reqpack { beez = { { name = "coditary/peachpie", version = "1.0.0", source = "github:Coditary/beez-peachpie" } } }
```

## Usage

```lua
configure({ { "coditary/peachpie", {} } })
```

```bash
beez -p setup[peachpie]
beez -p compile[peachpie]
beez -p bundle[peachpie]
beez -p test[test]
```

## Detection

| Marker | Action |
|--------|--------|
| `*.phpproj` | `dotnet restore` / `dotnet build` / `dotnet test` via Peachpie.NET.Sdk |
| `composer.json` | Project root hint (requires `*.phpproj` for build) |
| `**/*.php` | Source inputs for cache invalidation |

Build output: `build/peachpie/`

## License

Apache License 2.0.
