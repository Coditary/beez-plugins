# clojure

Official JVM Clojure compiler plugin — `clojure` CLI and Leiningen with auto-detected project manifests.

Plugin ID: **`coditary/clojure`**

## Install

```lua
reqpack { beez = { { name = "coditary/clojure", version = "1.0.0", source = "github:Coditary/beez-clojure" } } }
```

## Usage

```lua
configure({ { "coditary/clojure", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[jvm]
beez -s clojure:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `clojure -P` / `lein deps` | Resolves deps from `deps.edn` or `project.clj` |
| compile | `clojure -M:build` / `lein compile` | Output under `build/clojure/` |
| bundle | verify artifacts | Checks `build/clojure/**` |
| test | `clojure -M:test` / `lein test` | Uses `:test` alias or Leiningen test task |

## Detection

- Markers: `deps.edn`, `project.clj`, `**/*.clj`, `**/*.cljc`
- Prefers `project.clj` (Leiningen), then `deps.edn` (tools.deps), then plain sources

## License

Apache License 2.0.
