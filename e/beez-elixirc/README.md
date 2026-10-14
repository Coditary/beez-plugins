# elixirc

Official Elixir compiler plugin — `mix` or standalone `elixirc` with auto-detected sources.

Plugin ID: **`coditary/elixirc`**

## Install

```lua
reqpack { beez = { { name = "coditary/elixirc", version = "1.0.0", source = "github:Coditary/beez-elixirc" } } }
```

## Usage

```lua
configure({ { "coditary/elixirc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[elixir]
beez -s elixirc:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `mix.exs` | mix (`deps.get`, `compile`, `test`) |
| `**/*.ex` / `**/*.exs` (no mix.exs) | Standalone `elixirc` |

BEAM bytecode is collected under `build/elixirc/ebin/`.

## Scope

Release builds use scope **`elixir`** (not `app`), matching Elixir pipeline conventions.

## License

Apache License 2.0.
