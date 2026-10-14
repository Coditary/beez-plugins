# xla

Official XLA plugin — Accelerated Linear Algebra ML compiler for MLIR, SavedModel, and tf2xla scripts.

Plugin ID: **`coditary/xla`**

## Install

```lua
reqpack { beez = { { name = "coditary/xla", version = "1.0.0", source = "github:Coditary/beez-xla" } } }
```

## Usage

```lua
configure({ { "coditary/xla", {} } })
```

```bash
beez -p compile[xla]
beez -s xla:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `xla` | `pip install tensorflow` | Verifies XLA/TF toolchain |
| compile | `xla` | `xla-opt` / tf2xla script | Generates `build/xla/output.mlir` |
| bundle | `xla` | verify output | Checks compilation artifact |
| test | `xla` | MLIR verify | Validates XLA pipeline |

## Detection

- Markers: `**/*.mlir`, `xla_config.json`, `**/xla/*.json`, `saved_model.pb`, `**/*xla*.py`
- Entry priority: MLIR → SavedModel → tf2xla script → XLA config
- Tools: `xla-opt` (fallback `mlir-opt`), TensorFlow SavedModel loader

## License

Apache License 2.0.
