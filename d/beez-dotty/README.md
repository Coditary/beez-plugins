# dotty

Official Scala 3 / Dotty compiler plugin — `scalac` (Scala 3) standalone or sbt `compile` with auto-detected sources.

Plugin ID: **`coditary/dotty`**

## Install

```lua
reqpack { beez = { { name = "coditary/dotty", version = "1.0.0", source = "github:Coditary/beez-dotty" } } }
```

## Usage

```lua
configure({ { "coditary/dotty", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[dotty]
beez -s dotty:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.sbt`, `project/build.properties` | sbt (`update`, `compile`, `test`) |
| `**/*.scala` (no sbt build) | Standalone Scala 3 `scalac` |

Artifacts are collected under `build/dotty/` (`classes/`, `bin/`).

## Scope

Release builds use scope **`dotty`**, separating Scala 3 projects from Scala 2 (`coditary/scalac`, scope `jvm`).

## License

Apache License 2.0.
