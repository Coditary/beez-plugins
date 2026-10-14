# ecj

Eclipse Compiler for Java (**ECJ**) — compile Java projects with auto-detected Maven, Gradle, or plain layouts.

Plugin ID: **`coditary/ecj`**

## Install

```lua
reqpack { beez = { { name = "coditary/ecj", version = "1.0.0", source = "github:Coditary/beez-ecj" } } }
```

## Usage

```lua
configure({ { "coditary/ecj", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[ecj]
beez -s ecj:compile:code
```

## Configuration

| Option | Default | Description |
|--------|---------|-------------|
| `ecj_binary` | `ecj` | ECJ executable on PATH |
| `ecj_jar` | `""` | When set, invoke `java -jar <ecj_jar>` instead |
| `source_level` | `17` | Java source level |
| `target_level` | `17` | Java target level |

## Detection

Auto-detects projects via `pom.xml`, `build.gradle`, or `**/*.java`. Output goes to `build/ecj/`.

## License

Apache License 2.0.
