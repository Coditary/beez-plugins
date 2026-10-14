# chisel

Official Chisel plugin — compile Chisel/Scala hardware designs via sbt.

Plugin ID: **`coditary/chisel`**

## Install

```lua
reqpack { beez = { { name = "coditary/chisel", version = "1.0.0", source = "github:Coditary/beez-chisel" } } }
```

## Usage

```lua
configure({ { "coditary/chisel", {} } })
```

```bash
beez -p compile[chisel]
beez -s chisel:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `chisel` | `sbt update` | Resolves Chisel dependencies |
| compile | `chisel` | `sbt compile` | Copies classes/jars to `build/chisel/` |
| bundle | `chisel` | verify artifacts | Checks classes and jar output |
| test | `chisel` | `sbt test` | Skipped when no test sources are detected |

## Detection

- Markers: `build.sbt`, `**/*.scala`
- Project root: directory containing `build.sbt`
- Tests: `src/test/scala/**/*.scala`, `*Test.scala`, `*Spec.scala`

## License

Apache License 2.0.
