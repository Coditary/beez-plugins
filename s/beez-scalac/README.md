# scalac

Official Scala/JVM compiler plugin — `scalac` standalone or sbt `compile` with auto-detected sources.

Plugin ID: **`coditary/scalac`**

## Install

```lua
reqpack { beez = { { name = "coditary/scalac", version = "1.0.0", source = "github:Coditary/beez-scalac" } } }
```

## Usage

```lua
configure({ { "coditary/scalac", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[jvm]
beez -s scalac:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.sbt`, `build.sc`, `project/build.properties` | sbt (`update`, `compile`, `test`) |
| `**/*.scala` (no sbt build) | Standalone `scalac` |

Artifacts are collected under `build/scalac/` (`classes/`, `bin/`).

## Scope

Release builds use scope **`jvm`** (not `app`), matching Scala/JVM pipeline conventions.

## License

Apache License 2.0.
