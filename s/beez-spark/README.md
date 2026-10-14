# spark

Official spark compiler plugin — GNATprove SPARK Ada — verify **/*.ads, **/*.adb, and *.spark.

Plugin ID: **`coditary/spark`**

## Install

```lua
reqpack { beez = { { name = "coditary/spark", version = "1.0.0", source = "github:Coditary/beez-spark" } } }
```

## Usage

```lua
configure({ { "coditary/spark", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[spark]
beez -s spark:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `gnatprove` | Prepare `build/spark/` |
| compile | `gnatprove` on sources | Writes artifacts under `build/spark/` |
| bundle | verify compile artifacts | Checks output files |
| test | verify primary output | Writes `report/test/spark-*.ok` |

## Detection

- Markers: `**/*.ads`, `**/*.adb`, `*.spark`, `**/*.spark`
- Run `gnatprove` on SPARK Ada sources and `.spark` project files.
- Binary: `gnatprove` (override with `GNATPROVE` env or `spark_binary` config)

## License

Apache License 2.0.
