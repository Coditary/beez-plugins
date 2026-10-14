# moarvm

MoarVM JIT backend for Raku — verifies `moar`/`nqp` binaries, compiles NQP sources, and validates MoarVM bytecode.

Plugin ID: **`coditary/moarvm`**

## Install

```lua
reqpack { beez = { { name = "coditary/moarvm", version = "1.0.0", source = "github:Coditary/beez-moarvm" } } }
```

## Usage

```lua
configure({ { "coditary/moarvm", {} } })
```

```bash
beez -p compile[moarvm]
beez -s moarvm:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `command -v moar && command -v nqp` | Verifies MoarVM toolchain |
| compile | `nqp -c` / verify `.moar` | Syntax-check NQP; validate Moar bytecode files |
| bundle | verify compile stamp | Checks `build/moarvm/.moarvm-compile` |
| test | `nqp` / `moar` on `t/` | Writes `report/test/moarvm-*.ok` |

## Detection

- Markers: `**/*.nqp`, `**/*.moar`
- Tests: `t/*.nqp`, `t/**/*.nqp`, `t/*.t`
- Scope: `moarvm` (separate from `coditary/rakudo`)
- Binaries: `moar`, `nqp` (override with `MOAR` / `NQP` env or config)

## License

Apache License 2.0.
