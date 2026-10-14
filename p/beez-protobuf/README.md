# protobuf

Official Google protoc plugin — generate C++ code from Protocol Buffer definitions.

Plugin ID: **`coditary/protobuf`**

## Install

```lua
reqpack { beez = { { name = "coditary/protobuf", version = "1.0.0", source = "github:Coditary/beez-protobuf" } } }
```

## Usage

```lua
configure({ { "coditary/protobuf", {} } })
```

```bash
beez -p compile[protobuf]
beez -s protobuf:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `protobuf` | `protoc --version` | Verifies protoc binary |
| compile | `protobuf` | `protoc --cpp_out=…` | Generates C++ from `*.proto` |
| bundle | `protobuf` | verify output | Checks generated `.pb.h` files |
| test | `protobuf` | regenerate test output | Validates proto compilation |

## Detection

- Markers: `**/*.proto`
- Entry point: `message.proto` / `messages.proto`, or first non-test proto file, or `entry_source` in configure()
- Output: `build/protobuf/bin/*.pb.h` and `.pb.cc`

## License

Apache License 2.0.
