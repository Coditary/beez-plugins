# javac

Oracle/OpenJDK **javac** — Java bytecode compiler with Maven/Gradle auto-detection.

Plugin ID: **`coditary/javac`**

## Install

```lua
reqpack { beez = { { name = "coditary/javac", version = "1.0.0", source = "github:Coditary/beez-javac" } } }
```

## Usage

```lua
configure({ { "coditary/javac", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[debug]
beez -s javac:test:unit
```

## Detection

The plugin detects Java projects via `ctx.glob`:

| Marker | Build system |
|--------|--------------|
| `pom.xml` | Maven (`mvn dependency:resolve`) |
| `build.gradle` / `build.gradle.kts` | Gradle (`./gradlew dependencies` or `gradle dependencies`) |
| `**/*.java` | Plain javac (no dependency fetch) |

Main classes are inferred from `Main.java`, `Application.java`, or `App.java` under `src/main/java/`.

## Output

| Profile | javac flags | Output |
|---------|-------------|--------|
| Release (`app`) | `-O` | `build/javac/classes`, `build/javac/bin/run` |
| Debug | `-g` | `build/javac/classes`, `build/javac/bin/run` |

## License

Apache License 2.0.
