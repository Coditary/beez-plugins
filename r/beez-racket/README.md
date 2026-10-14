# racket

Official Racket compiler plugin — `raco make` with auto-detected `info.rkt` and module sources.

Plugin ID: **`coditary/racket`**

## Install

```lua
reqpack { beez = { { name = "coditary/racket", version = "1.0.0", source = "github:Coditary/beez-racket" } } }
```

## Usage

```lua
configure({ { "coditary/racket", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[racket]
beez -s racket:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `raco pkg install --skip-installed --auto` | Skipped when no `info.rkt` manifest |
| compile | `raco make` | Compiles all detected `.rkt` modules |
| bundle | verify sources | Checks compiled module paths |
| test | `raco test` | Runs Racket test suite |

## Detection

- Markers: `info.rkt`, `**/*.rkt`
- Entry points: `main.rkt`, `src/main.rkt`, or first non-test module

## License

Apache License 2.0.
