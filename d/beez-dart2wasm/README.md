# dart2wasm

Official Dart-to-WebAssembly compiler — `dart compile wasm -O4` with auto-detected targets.

Plugin ID: **`coditary/dart2wasm`**

## Install

```lua
reqpack { beez = { { name = "coditary/dart2wasm", version = "1.0.0", source = "github:Coditary/beez-dart2wasm" } } }
```

## Usage

```lua
configure({ { "coditary/dart2wasm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[wasm]
beez -s coditary/dart2wasm:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `dart pub get` | Skipped when no `pubspec.yaml` manifest |
| compile | `dart compile wasm -O4` | Output under `build/dart2wasm/` |
| bundle | verify WASM artifacts | Checks `build/dart2wasm/**/*.wasm` |
| test | `dart test` | Runs project test suite |

## Detection

- Markers: `pubspec.yaml`, `**/*.dart`
- Entry points: `web/main.dart`, `web/*.dart`, `bin/*.dart`, or first non-test `*.dart`

## License

Apache License 2.0.
