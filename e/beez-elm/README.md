# elm

Official Elm compiler — `elm make` with auto-detected `Main.elm` entry point.

Plugin ID: **`coditary/elm`**

## Install

```lua
reqpack { beez = { { name = "coditary/elm", version = "1.0.0", source = "github:Coditary/beez-elm" } } }
```

## Usage

```lua
configure({ { "coditary/elm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `elm --version`, `elm install` | Verifies elm binary; installs deps when `elm.json` exists |
| compile | `elm make src/Main.elm --output=build/elm/app.js` | Release uses `--optimize` |
| bundle | verify output | Checks `build/elm/app.js` |
| test | `elm-test-rs` or `elm-test` | Skipped when no test runner is installed |

## Detection

- Markers: `elm.json`, `**/*.elm`
- Entry point: `src/Main.elm`, `Main.elm`, or first `src/*.elm`

## License

Apache License 2.0.
