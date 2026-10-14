# swift-tf

**Swift for TensorFlow (S4TF)** compiler plugin — `swift build` with auto-detected targets using the historical S4TF toolchain.

> **Historical / discontinued:** Swift for TensorFlow was an experimental Google project that is no longer maintained. The S4TF toolchain (`swift` with TensorFlow bindings) is frozen and may not build on current OS versions. This plugin exists for legacy projects and archival builds only.

Plugin ID: **`coditary/swift-tf`**

Scope: **`swift-tf`**

## Install

```lua
reqpack { beez = { { name = "coditary/swift-tf", version = "1.0.0", source = "github:Coditary/beez-swift-tf" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/swift-tf", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/swift-tf", {} } })
```

```bash
beez -p setup[swift-tf]
beez -p compile[swift-tf]
beez -p bundle[swift-tf]
beez -p test[test]
beez -s coditary/swift-tf:configure:setup
beez -s coditary/swift-tf:compile:code
```

Build artifacts are written to `build/swift-tf/` (release binaries: `build/swift-tf/release/`).

## Requirements

- S4TF toolchain (`swift`, `swiftc`) on `PATH` — not the standard Apple Swift toolchain
- A Swift package with `Package.swift` and `**/*.swift` sources

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `configure:setup` | setup | swift-tf | Resolve package dependencies |
| `compile:code` | compile | swift-tf | Release build |
| `bundle:code` | bundle | swift-tf | Verify binaries |
| `test:unit` | test | test | Run package tests |

## License

Apache License 2.0.
