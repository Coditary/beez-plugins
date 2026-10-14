# rustc-gcc

Rust compiler with GCC backend — `cargo build` with `RUSTFLAGS="-C codegen-backend=gcc"` and auto-detected targets.

Plugin ID: **`coditary/rustc-gcc`**

## Prerequisites

**Nightly `rustc_codegen_gcc` is typically required.** Install a toolchain that includes the GCC codegen backend:

```bash
# Example: rustup nightly with gcc codegen support
rustup toolchain install nightly
# Or a custom +nightly-gcc toolchain when available:
# rustup toolchain install nightly-gcc
```

Verify the backend is available:

```bash
rustc +nightly -C codegen-backend=gcc --version
```

## Install

```lua
reqpack { beez = { { name = "coditary/rustc-gcc", version = "1.0.0", source = "github:Coditary/beez-rustc-gcc" } } }
```

## Usage

```lua
configure({ { "coditary/rustc-gcc", {} } })
workflows({ build = "coditary/rustc-gcc:build" })
```

```bash
beez build
beez -s rustc-gcc:compile
beez -p compile[rustc-gcc]
```

## Defaults

- `RUSTFLAGS="-C codegen-backend=gcc"` for all `cargo` invocations
- Separate target dir: `target/rustc-gcc/` (does not conflict with `coditary/cargo`)
- Scope: `rustc-gcc`
- Auto-detects `Cargo.toml`, `src/main.rs`, `src/bin/*.rs`

## Direct `rustc` invocation

By default the plugin uses `cargo build`. For direct `rustc` with a nightly GCC toolchain, set in `configure()`:

```lua
configure({
    { "coditary/rustc-gcc", {
        use_rustc = true,
        rust_toolchain = "nightly-gcc",  -- enables `rustc +nightly-gcc -C codegen-backend=gcc`
    }},
})
```

This path invokes `rustc +<toolchain> -C codegen-backend=gcc` for single-crate `src/main.rs` builds.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `rustc-gcc:configure` | setup | rustc-gcc | `cargo fetch` with GCC backend flags |
| `rustc-gcc:compile` | compile | rustc-gcc | `cargo build --release` with `RUSTFLAGS` |
| `rustc-gcc:compile:debug` | compile | rustc-gcc | `cargo build` (debug) |
| `rustc-gcc:bundle` | bundle | rustc-gcc | Verify release binaries |
| `rustc-gcc:test` | test | rustc-gcc | `cargo test` with `RUSTFLAGS` |

## License

Apache License 2.0.
