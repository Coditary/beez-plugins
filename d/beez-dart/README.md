# dart

Official Dart compiler — `dart compile exe` with auto-detected targets (AOT native executables).

Plugin ID: **`coditary/dart`**

## Install

```lua
reqpack { beez = { { name = "coditary/dart", version = "1.0.0", source = "github:Coditary/beez-dart" } } }
```

## Usage

```lua
configure({ { "coditary/dart", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `dart pub get` | Skipped when no `pubspec.yaml` manifest |
| compile | `dart compile exe` | Output under `build/dart/bin/` |
| bundle | verify binaries | Checks `build/dart/bin/**` |
| test | `dart test` | Runs project test suite |

## Detection

- Markers: `pubspec.yaml`, `**/*.dart`
- Entry points: `bin/*.dart`, `lib/main.dart`, or first non-test `*.dart`

## License

Apache License 2.0.
