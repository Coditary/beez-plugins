# groovy

Official Groovy compiler plugin — groovyc with auto-detected source targets.

Plugin ID: **`coditary/groovy`**

## Install

```lua
reqpack { beez = { { name = "coditary/groovy", version = "1.0.0", source = "github:Coditary/beez-groovy" } } }
```

## Usage

```lua
configure({ { "coditary/groovy", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[groovy]
beez -s groovy:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `groovyc` | Verify compiler and prepare `build/groovy/` |
| compile | `groovyc` | Compile via `groovyc -d build/groovy` or Gradle when `build.gradle` is present. |
| bundle | verify artifacts | Checks outputs under `build/groovy/` |
| test | `prove -l t/` | Writes `report/test/groovy-*.ok` |

## Detection

- Markers: `**/*.groovy`, `build.gradle`, `**/build.gradle`
- Scope: `groovy`
- Binary: `groovyc` (override with `GROOVYC` env or `groovy_binary` config)

## License

Apache License 2.0.
