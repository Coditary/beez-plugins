# rustc-cranelift

Rust compiler with Cranelift backend for fast debug builds — `cargo build` with `CARGO_PROFILE_DEV_CODEGEN_BACKEND=cranelift`.

Plugin ID: **`coditary/rustc-cranelift`**

## Install

```lua
reqpack { beez = { { name = "coditary/rustc-cranelift", version = "1.0.0", source = "github:Coditary/beez-rustc-cranelift" } } }
```

## Usage

```lua
configure({ { "coditary/rustc-cranelift", {} } })
workflows({ build = "coditary/rustc-cranelift:build" })
```

```bash
beez build
beez -s rustc-cranelift:compile
beez -p compile[cranelift]
```

## Defaults

- `cargo build` with `CARGO_PROFILE_DEV_CODEGEN_BACKEND=cranelift` and `RUSTFLAGS="-C codegen-backend=cranelift"`
- `cargo fetch` for dependency setup
- Outputs to `target/cranelift/debug/<name>`
- Scope: `cranelift` (does not conflict with `coditary/cargo`)

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `rustc-cranelift:configure` | setup | cranelift | `cargo fetch` |
| `rustc-cranelift:compile` | compile | cranelift | `cargo build` (Cranelift) |
| `rustc-cranelift:bundle` | bundle | cranelift | Verify debug binaries |
| `rustc-cranelift:test` | test | cranelift | `cargo test` (Cranelift) |

## License

Apache License 2.0.
