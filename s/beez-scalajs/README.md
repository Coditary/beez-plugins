# scalajs

Official Scala.js transpiler plugin — `scalajs` standalone or sbt `fastOptJS` / `fullOptJS` with auto-detected sources.

Plugin ID: **`coditary/scalajs`**

## Install

```lua
reqpack { beez = { { name = "coditary/scalajs", version = "1.0.0", source = "github:Coditary/beez-scalajs" } } }
```

## Usage

```lua
configure({ { "coditary/scalajs", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[js]
beez -s scalajs:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.sbt` | sbt (`fullOptJS`, `fastOptJS`, `test`) |
| `**/*.scala` (no build.sbt) | Standalone `scalajs` |

JavaScript output is collected under `build/scalajs/` (`js/`, `bin/`).

## Scope

Release builds use scope **`js`**, matching Scala.js pipeline conventions.

## License

Apache License 2.0.
