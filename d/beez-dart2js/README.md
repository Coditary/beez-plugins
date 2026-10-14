# dart2js

Official Dart-to-JavaScript transpiler — `dart compile js -O4` with auto-detected web targets.

Plugin ID: **`coditary/dart2js`**

## Install

```lua
reqpack { beez = { { name = "coditary/dart2js", version = "1.0.0", source = "github:Coditary/beez-dart2js" } } }
```

## Usage

```lua
configure({ { "coditary/dart2js", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[js]
beez -s coditary/dart2js:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `dart pub get` | Skipped when no `pubspec.yaml` manifest |
| compile | `dart compile js -O4` | Output under `build/dart2js/` |
| bundle | verify JS artifacts | Checks `build/dart2js/**/*.js` |
| test | `dart test` | Runs project test suite |

## Detection

- Markers: `pubspec.yaml`, `**/*.dart`, `web/index.html`
- Entry points: `web/main.dart`, `web/*.dart`, `bin/*.dart`, or first non-test `*.dart`

## License

Apache License 2.0.
