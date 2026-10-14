# gleam

Official Gleam compiler plugin — `gleam deps download`, `gleam build`, and `gleam test` with auto-detected sources.

Plugin ID: **`coditary/gleam`**

## Install

```lua
reqpack { beez = { { name = "coditary/gleam", version = "1.0.0", source = "github:Coditary/beez-gleam" } } }
```

## Usage

```lua
configure({ { "coditary/gleam", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[gleam]
beez -s gleam:compile
```

## Detection

| Marker | Action |
|--------|--------|
| `gleam.toml` | Project root (`gleam deps download`, `gleam build`, `gleam test`) |
| `src/**/*.gleam` | Gleam source inputs |

BEAM bytecode is collected under `build/gleam/ebin/`.

## Scope

Release builds use scope **`gleam`** (not `app`), matching Gleam pipeline conventions.

## License

Apache License 2.0.
