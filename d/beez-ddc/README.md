# ddc

Official Dart Dev Compiler (DDC) plugin — `dart compile js` for development JavaScript output.

Plugin ID: **`coditary/ddc`**

## Install

```lua
reqpack { beez = { { name = "coditary/ddc", version = "1.0.0", source = "github:Coditary/beez-ddc" } } }
```

## Usage

```lua
configure({ { "coditary/ddc", {} } })
```

```bash
beez -p compile[ddc]
beez -s coditary/ddc:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `dart pub get` | Skipped when no `pubspec.yaml` manifest |
| compile | `dart compile js --no-sound-null-safety` | Output under `build/ddc/` |
| bundle | verify `.js` files | Checks `build/ddc/**` |
| test | `dart test` | Runs project test suite |

## Detection

- Markers: `pubspec.yaml`, `**/*.dart`
- Entry points: `bin/*.dart`, `web/main.dart`, `lib/main.dart`, or first non-test `*.dart`

## Legacy dartdevc

Set `use_dartdevc = true` in `configure()` to use the legacy `dartdevc` binary instead of `dart compile js`.

## License

Apache License 2.0.
