# kotlin-wasm

Official Kotlin/Wasm compiler plugin — `kotlin-wasm` standalone or Gradle `wasmJs` with auto-detected sources.

Plugin ID: **`coditary/kotlin-wasm`**

## Install

```lua
reqpack { beez = { { name = "coditary/kotlin-wasm", version = "1.0.0", source = "github:Coditary/beez-kotlin-wasm" } } }
```

## Usage

```lua
configure({ { "coditary/kotlin-wasm", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[wasm]
beez -s kotlin-wasm:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `build.gradle.kts` / `build.gradle` | Gradle (`compileProductionExecutableWasmJs`, `wasmJsBrowserTest`) |
| `**/*.kt` (no Gradle) | Standalone `kotlin-wasm` |

WebAssembly output is collected under `build/kotlin-wasm/` (`wasm/`, `bin/`).

## Scope

Release builds use scope **`wasm`**, matching Kotlin/Wasm pipeline conventions.

## Other Kotlin compilers

| Plugin | Target | Use case |
|--------|--------|----------|
| `coditary/kotlinc` | **JVM** | Server/desktop Kotlin |
| `coditary/kotlin-js` | **JS** | Browser/Node JavaScript |
| `coditary/kotlin-native` | **Native** | LLVM native binaries |
| `coditary/kotlin-wasm` | **Wasm** | WebAssembly (this plugin) |

## License

Apache License 2.0.
