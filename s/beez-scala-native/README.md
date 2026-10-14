# scala-native

Scala/Native LLVM compiler plugin — `scala-native` standalone or sbt `nativeLink` with auto-detected sources.

Plugin ID: **`coditary/scala-native`**

## Install

```lua
reqpack { beez = { { name = "coditary/scala-native", version = "1.0.0", source = "github:Coditary/beez-scala-native" } } }
```

## Usage

```lua
configure({ { "coditary/scala-native", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[native]
beez -s scala-native:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.sbt` + `nativeConfig` / `project/plugins.sbt` | sbt (`nativeLink`, `test`) |
| `**/*.scala` (no sbt) | Standalone `scala-native compile` |

Native binaries are collected under `build/scala-native/bin/`.

## Scope

Release builds use scope **`native`**, matching Scala/Native pipeline conventions.

## Other Scala compilers

| Plugin | Target | Use case |
|--------|--------|----------|
| `coditary/scalac` | **JVM** | Scala on the JVM |
| `coditary/scala-native` | **Native** | LLVM native executables (this plugin) |

Load only the compiler plugin you need.

## License

Apache License 2.0.
