# swift

Apple Swift compiler (**swiftc**, LLVM-based) — `swift build` with auto-detected targets.

Plugin ID: **`coditary/swift`**

## Install

```lua
reqpack { beez = { { name = "coditary/swift", version = "1.0.0", source = "github:Coditary/beez-swift" } } }
```

## Usage

```lua
configure({ { "coditary/swift", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

Build artifacts are written to `build/swift/` (release: `build/swift/release/`).

## Requirements

- Swift toolchain (`swift`, `swiftc`) on `PATH`
- A Swift package with `Package.swift`

## License

Apache License 2.0.
