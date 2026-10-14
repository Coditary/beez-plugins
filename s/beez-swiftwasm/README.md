# swiftwasm

SwiftWasm — compile Swift to WebAssembly with the SwiftWasm SDK (`swift`, `wasm-ld`).

Plugin ID: **`coditary/swiftwasm`**

## Install

```lua
reqpack { beez = { { name = "coditary/swiftwasm", version = "1.0.0", source = "github:Coditary/beez-swiftwasm" } } }
```

## Usage

```lua
configure({
  { "coditary/swiftwasm", {
    swift_sdk = "swift-6.0.0_wasm", -- or set SWIFT_WASM_SDK env var
  }},
})
workflows({ wasm = "coditary/swiftwasm:wasm" })
```

```bash
beez wasm
beez -p compile[wasm]
```

Build artifacts are written to `build/swiftwasm/` (Wasm binaries: `build/swiftwasm/wasm/`).

## Requirements

- SwiftWasm SDK on `PATH` (`swift`, `wasm-ld`)
- A Swift package with `Package.swift` or `Package@swift-5.9-wasm.swift`
- `SWIFT_WASM_SDK` environment variable or `swift_sdk` in `configure()`

## License

Apache License 2.0.
