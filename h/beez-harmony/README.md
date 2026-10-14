# harmony

**Apache Harmony DRLVM** — historical open-source JVM with JIT for Java projects.

Plugin ID: **`coditary/harmony`**

> **Historical notice:** [Apache Harmony](https://harmony.apache.org/) was an open-source Java SE implementation whose **DRLVM** (Dynamic Runtime Layer Virtual Machine) provided a JIT-capable JVM. The project was discontinued in 2011 after Oracle donated OpenJDK to the community. This plugin is maintained for legacy codebases, research, and toolchain archaeology. For modern Java projects, use OpenJDK `javac`, Eclipse ECJ, or GraalVM instead.

## Install

```lua
reqpack { beez = { { name = "coditary/harmony", version = "1.0.0", source = "github:Coditary/beez-harmony" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/harmony", path = ".", version = "1.0.0" } } }
```

Then: `beez --install`

## Usage

Ensure Harmony/DRLVM `java` and `javac` are on `PATH` (or set `java_binary` / `javac_binary` in config).

```lua
configure({ { "coditary/harmony", {} } })
```

```bash
beez -p setup[harmony]
beez -p compile[harmony]
beez -p bundle[harmony]
beez -p test[harmony]
beez -s coditary/harmony:compile:code
```

## Detection

The plugin detects Java projects via `ctx.glob`:

| Marker | Build system |
|--------|--------------|
| `pom.xml` | Maven (`mvn dependency:resolve`) |
| `build.gradle` / `build.gradle.kts` | Gradle (`./gradlew dependencies` or `gradle dependencies`) |
| `**/*.java` | Plain javac (no dependency fetch) |

Main classes are inferred from `Main.java`, `Application.java`, or `App.java` under `src/main/java/`.

## Steps

| Step | Phase | Scope | Output |
|------|-------|-------|--------|
| `configure:setup` | setup | harmony | `build/harmony/.deps-fetched` |
| `compile:code` | compile | harmony | `build/harmony/classes/**` |
| `bundle:code` | bundle | harmony | `build/harmony/bin/run` |
| `test:unit` | test | harmony | `report/test/harmony-code.ok` |

Debug variants (`compile:debug`, `bundle:debug`, `test:debug`) compile with `-g` debug symbols.

## Output

| Profile | javac flags | Output |
|---------|-------------|--------|
| Release (`harmony`) | `-O` | `build/harmony/classes`, `build/harmony/bin/run` |
| Debug | `-g` | `build/harmony/classes`, `build/harmony/bin/run` |

The bundle step creates a launcher script that invokes Harmony/DRLVM `java` to run the detected main class.

## License

Apache License 2.0.
