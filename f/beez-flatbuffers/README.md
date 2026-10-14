# flatbuffers

Official flatc FlatBuffers compiler plugin — generate C++ headers from schema files.

Plugin ID: **`coditary/flatbuffers`**

## Install

```lua
reqpack { beez = { { name = "coditary/flatbuffers", version = "1.0.0", source = "github:Coditary/beez-flatbuffers" } } }
```

## Usage

```lua
configure({ { "coditary/flatbuffers", {} } })
```

```bash
beez -p compile[flatbuffers]
beez -s flatbuffers:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `flatbuffers` | `flatc --version` | Verifies flatc binary |
| compile | `flatbuffers` | `flatc --cpp -o …` | Generates C++ from `*.fbs` |
| bundle | `flatbuffers` | verify output | Checks generated headers |
| test | `flatbuffers` | regenerate test output | Validates schema compilation |

## Detection

- Markers: `**/*.fbs`
- Entry point: `schema.fbs`, or first non-test `.fbs` file, or `entry_source` in configure()
- Output: `build/flatbuffers/bin/*.h` with object API (code profile)

## License

Apache License 2.0.
