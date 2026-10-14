# clojureclr

ClojureCLR (.NET port of Clojure) — `clojure.compile` and `dotnet build` with auto-detected projects.

Plugin ID: **`coditary/clojureclr`**

## Install

```lua
reqpack { beez = { { name = "coditary/clojureclr", version = "1.0.0", source = "github:Coditary/beez-clojureclr" } } }
```

## Usage

```lua
configure({ { "coditary/clojureclr", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[clojureclr]
beez -s clojureclr:compile
```

## Detection

| Marker | Toolchain |
|--------|-----------|
| `*.sln`, `*.csproj` | `dotnet restore` / `dotnet build` / `dotnet test` |
| `project.clj` | `lein deps` / `lein compile` / `lein test` |
| `deps.edn` | `clojure -P` / `clojure.compile` |
| `**/*.clj` (no project) | `clojure.compile` standalone |

Build output: `build/clojureclr/`

## License

Apache License 2.0.
