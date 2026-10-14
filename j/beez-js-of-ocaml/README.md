# js-of-ocaml

Official js_of_ocaml transpiler plugin — `dune` build or standalone `js_of_ocaml` with auto-detected OCaml sources.

Plugin ID: **`coditary/js-of-ocaml`**

## Install

```lua
reqpack { beez = { { name = "coditary/js-of-ocaml", version = "1.0.0", source = "github:Coditary/beez-js-of-ocaml" } } }
```

## Usage

```lua
configure({ { "coditary/js-of-ocaml", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[js]
beez -s js-of-ocaml:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `dune-project` | dune (`dune build @all`, `dune runtest`) |
| `**/*.ml` (no dune-project) | Standalone `js_of_ocaml` via ocamlfind |
| `jsoo.config.mli` | js_of_ocaml compiler configuration |

JavaScript output is collected under `build/js-of-ocaml/` (`js/`, `bin/`).

## Scope

Release builds use scope **`js`**, matching js-of-ocaml pipeline conventions.

## License

Apache License 2.0.
