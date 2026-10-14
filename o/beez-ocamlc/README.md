# ocamlc

Official OCaml bytecode compiler plugin — `ocamlc` standalone or dune `build` with auto-detected sources.

Plugin ID: **`coditary/ocamlc`**

## Install

```lua
reqpack { beez = { { name = "coditary/ocamlc", version = "1.0.0", source = "github:Coditary/beez-ocamlc" } } }
```

## Usage

```lua
configure({ { "coditary/ocamlc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[bytecode]
beez -s ocamlc:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `dune-project`, `dune` | dune (`build --dry-run`, `build @install`, `runtest`) |
| `**/*.ml`, `**/*.mli` (no dune project) | Standalone `ocamlc` |

Artifacts are collected under `build/ocamlc/` (`bytecode/`, `bin/`).

## Scope

Release builds use scope **`bytecode`** (not `app`), matching OCaml bytecode pipeline conventions.

## License

Apache License 2.0.
