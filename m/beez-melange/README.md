# melange

Official Melange compiler plugin — `dune build @melange` or standalone `melange compile` with auto-detected OCaml/Reason sources.

Plugin ID: **`coditary/melange`**

## Install

```lua
reqpack { beez = { { name = "coditary/melange", version = "1.0.0", source = "github:Coditary/beez-melange" } } }
```

## Usage

```lua
configure({ { "coditary/melange", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[melange]
beez -s melange:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `dune-project` | dune (`dune build @melange`, `dune runtest`) |
| `melange.json` | dune (Melange project configuration) |
| `**/*.ml` / `**/*.re` (no dune-project) | Standalone `melange compile` |

JavaScript output is collected under `build/melange/` (`js/`, `bin/`).

## Scope

Release builds use scope **`melange`**, matching Melange pipeline conventions.

## License

Apache License 2.0.
