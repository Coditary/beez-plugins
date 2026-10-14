# ocamlopt

Official OCaml native code compiler plugin — `ocamlopt` standalone or dune `build -p` with auto-detected sources.

Plugin ID: **`coditary/ocamlopt`**

## Install

```lua
reqpack { beez = { { name = "coditary/ocamlopt", version = "1.0.0", source = "github:Coditary/beez-ocamlopt" } } }
```

## Usage

```lua
configure({ { "coditary/ocamlopt", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[native]
beez -s ocamlopt:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `dune build --dry-run` | Skipped when no dune project |
| compile | `dune build -p` / `ocamlopt` | Output under `build/ocamlopt/bin/` |
| bundle | verify binaries | Checks `build/ocamlopt/bin/**` |
| test | `dune runtest` | Uses dune test when available |

## Detection

| Marker | Backend |
|--------|---------|
| `dune-project`, `dune` | dune (`build --dry-run`, `build -p`, `runtest`) |
| `**/*.ml`, `**/*.mli` (no dune project) | Standalone `ocamlopt` |

Artifacts are collected under `build/ocamlopt/` (`obj/`, `bin/`).

## Scope

Release builds use scope **`native`**, matching OCaml native pipeline conventions.

## Other OCaml compilers

| Plugin | Compiler | Use case |
|--------|----------|----------|
| `coditary/ocamlc` | **ocamlc** | Bytecode (`.byte`, `.cmo`) |
| `coditary/ocamlopt` | **ocamlopt** | Native executables (this plugin) |

## License

Apache License 2.0.
