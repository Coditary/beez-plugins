# kotlinc

Official Kotlin/JVM compiler plugin — `kotlinc` standalone or Gradle `compileKotlin` with auto-detected sources.

Plugin ID: **`coditary/kotlinc`**

## Install

```lua
reqpack { beez = { { name = "coditary/kotlinc", version = "1.0.0", source = "github:Coditary/beez-kotlinc" } } }
```

## Usage

```lua
configure({ { "coditary/kotlinc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[jvm]
beez -s kotlinc:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.gradle.kts` / `build.gradle` | Gradle (`compileKotlin`, `test`) |
| `**/*.kt` (no Gradle) | Standalone `kotlinc` |

Artifacts are collected under `build/kotlinc/` (`classes/`, `bin/`).

## Scope

Release builds use scope **`jvm`** (not `app`), matching Kotlin/JVM pipeline conventions.

## License

Apache License 2.0.
