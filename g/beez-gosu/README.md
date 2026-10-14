# gosu

Official Gosu JVM language plugin — `gosu compile` with auto-detected `.gs` and Maven targets.

Plugin ID: **`coditary/gosu`**

## Install

```lua
reqpack { beez = { { name = "coditary/gosu", version = "1.0.0", source = "github:Coditary/beez-gosu" } } }
```

## Usage

```lua
configure({ { "coditary/gosu", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[gosu]
beez -s gosu:compile
```

## Steps

| Phase | Tool | Notes |
|-------|------|-------|
| setup | `gosu` | Verify compiler and prepare `build/gosu/` |
| compile | `gosu compile` / `mvn compile` | Compiles `.gs` or Maven project |
| bundle | verify artifacts | Checks outputs under `build/gosu/` or `target/classes/` |
| test | `mvn test` | Writes `report/test/gosu-*.ok` |

## Detection

- Markers: `**/*.gs`, `pom.xml`
- Scope: `gosu`
- Binary: `gosu` (override with `GOSU` env or `gosu_binary` config)

## License

Apache License 2.0.
