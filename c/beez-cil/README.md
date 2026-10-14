# cil

**.NET ilasm** — CIL assembler for `.il` sources.

Plugin ID: **`coditary/cil`**

## Install

```lua
reqpack { beez = { { name = "coditary/cil", version = "1.0.0", source = "github:Coditary/beez-cil" } } }
```

## Usage

```lua
configure({ { "coditary/cil", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[cil]
beez -s cil:compile:code
```

## Detection

| Marker | Toolchain |
|--------|-----------|
| `**/*.il` | `ilasm /output:build/cil/bin/app.exe` |

Entry points are inferred from `main.il`, `Main.il`, or the first non-test `.il` file.

## Output

| Profile | Scope | Output |
|---------|-------|--------|
| Release | `cil` | `build/cil/bin/*.exe` |
| Debug | `cil` | `build/cil/bin/*.exe` (`/DEBUG`) |

## License

Apache License 2.0.
