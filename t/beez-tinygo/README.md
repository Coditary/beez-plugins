# tinygo

TinyGo — LLVM-based Go compiler for WebAssembly and embedded systems.

Plugin ID: **`coditary/tinygo`**

## Install

```lua
reqpack { beez = { { name = "coditary/tinygo", version = "1.0.0", source = "github:Coditary/beez-tinygo" } } }
```

## Usage

```lua
configure({
    { "coditary/tinygo", {
        steps = {
            ["tinygo:compile:embedded"] = { tinygo_target = "esp32" },
        },
    }},
})
workflows({ wasm = "coditary/tinygo:wasm" })
```

```bash
beez wasm                    # Wasm workflow
beez -s tinygo:compile       # Wasm build
beez -s tinygo:compile:embedded   # MCU build
beez -p compile[wasm]
```

## Targets

Configure `tinygo_target` per step: `wasm`, `wasi`, `arduino`, `esp32`, `nrf52840`, …

## Defaults

- `-opt=2`, `-gc=leaking`, `-size=short`
- Auto `.wasm` suffix for Wasm targets
- Scopes: `wasm`, `embedded`

## License

Apache License 2.0.
