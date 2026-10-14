# kotlin-js

Official Kotlin/JS transpiler plugin — `kotlinc-js` standalone or Gradle `compileKotlinJs` with auto-detected sources.

Plugin ID: **`coditary/kotlin-js`**

## Install

```lua
reqpack { beez = { { name = "coditary/kotlin-js", version = "1.0.0", source = "github:Coditary/beez-kotlin-js" } } }
```

## Usage

```lua
configure({ { "coditary/kotlin-js", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[js]
beez -s kotlin-js:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.gradle.kts` / `build.gradle` | Gradle (`compileKotlinJs`, `jsTest`) |
| `**/*.kt` (no Gradle) | Standalone `kotlinc-js` |

JavaScript output is collected under `build/kotlin-js/` (`js/`, `bin/`).

## Scope

Release builds use scope **`js`**, matching Kotlin/JS pipeline conventions.

## Other Kotlin compilers

| Plugin | Target | Use case |
|--------|--------|----------|
| `coditary/kotlinc` | **JVM** | Server/desktop Kotlin |
| `coditary/kotlin-js` | **JS** | Browser/Node (this plugin) |

## License

Apache License 2.0.
