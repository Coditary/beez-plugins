# jikesrvm

**Jikes Research Virtual Machine (JikesRVM)** — research Java VM with an integrated optimizing compiler (JIT/AOT).

Plugin ID: **`coditary/jikesrvm`**

> **Research VM status:** JikesRVM is an academic/research virtual machine maintained for JVM research. It is not a production JDK replacement. This plugin compiles sources with host `javac`, then runs and tests bytecode via the JikesRVM `java` launcher. Ensure a built JikesRVM installation is on `PATH` (`jikesrvm`, `java`).

## Install

```lua
reqpack { beez = { { name = "coditary/jikesrvm", version = "1.0.0", source = "github:Coditary/beez-jikesrvm" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/jikesrvm", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/jikesrvm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[jikesrvm]
beez -p compile[debug]
beez -s jikesrvm:test:unit
```

## Detection

The plugin detects Java projects via `ctx.glob`:

| Marker | Build system |
|--------|--------------|
| `pom.xml` | Maven (`mvn dependency:resolve`) |
| `build.gradle` / `build.gradle.kts` | Gradle (`./gradlew dependencies` or `gradle dependencies`) |
| `**/*.java` | Plain javac (no dependency fetch) |

Main classes are inferred from `Main.java`, `Application.java`, or `App.java` under `src/main/java/`.

## Requirements

- **`jikesrvm`** and **`java`** (JikesRVM launcher) on `PATH`
- **`javac`** (host compiler for source → bytecode, standard JikesRVM workflow)

## Output

| Profile | javac flags | Output |
|---------|-------------|--------|
| Release (`jikesrvm`) | `-O` | `build/jikesrvm/classes`, `build/jikesrvm/bin/run` |
| Debug | `-g` | `build/jikesrvm/classes`, `build/jikesrvm/bin/run` |

## Steps

| Step | Phase | Scope | Output |
|------|-------|-------|--------|
| `configure:setup` | setup | jikesrvm | `build/jikesrvm/.deps-fetched` |
| `compile:code` | compile | jikesrvm | `build/jikesrvm/classes/**` |
| `bundle:code` | bundle | jikesrvm | `build/jikesrvm/bin/**` |
| `test:unit` | test | jikesrvm | `report/test/jikesrvm-code.ok` |

## License

Apache License 2.0.
