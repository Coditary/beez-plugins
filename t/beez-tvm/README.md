# tvm

Official Apache TVM plugin — deep learning compiler from Relay/TIR to native code.

Plugin ID: **`coditary/tvm`**

## Install

```lua
reqpack { beez = { { name = "coditary/tvm", version = "1.0.0", source = "github:Coditary/beez-tvm" } } }
```

## Usage

```lua
configure({ { "coditary/tvm", {} } })
```

```bash
beez -p compile[tvm]
beez -s tvm:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `tvm` | `pip install apache-tvm` | Installs TVM Python package |
| compile | `tvm` | TVM compile script | Generates `build/tvm/model.so` |
| bundle | `tvm` | verify output | Checks native code artifact |
| test | `tvm` | `pytest` | Validates TVM compilation |

## Detection

- Markers: `**/*.relay`, `**/*.tir`, `**/*compile*.py`, `**/*tvm*.py` with TVM imports
- Entry priority: TVM compile script → Relay → TIR
- Target: `llvm` (override with `tvm_target` config)

## License

Apache License 2.0.
