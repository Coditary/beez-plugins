# kotlin-native

Kotlin/Native LLVM compiler plugin — `kotlinc-native` standalone or Gradle `linkReleaseExecutableNative` with auto-detected sources.

Plugin ID: **`coditary/kotlin-native`**

## Install

```lua
reqpack { beez = { { name = "coditary/kotlin-native", version = "1.0.0", source = "github:Coditary/beez-kotlin-native" } } }
```

## Usage

```lua
configure({ { "coditary/kotlin-native", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[native]
beez -s kotlin-native:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.gradle.kts` / `build.gradle` | Gradle (`linkReleaseExecutableNative`, `nativeTest`) |
| `**/*.kt` (no Gradle) | Standalone `kotlinc-native` |

Native binaries are collected under `build/kotlin-native/bin/`.

## Scope

Release builds use scope **`native`**, matching Kotlin/Native pipeline conventions.

## Other Kotlin compilers

| Plugin | Target | Use case |
|--------|--------|----------|
| `coditary/kotlinc` | **JVM** | Kotlin on the JVM |
| `coditary/kotlin-native` | **Native** | LLVM native executables (this plugin) |

Load only the compiler plugin you need.

## License

Apache License 2.0.
