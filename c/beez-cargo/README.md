# cargo

Rust build, test, and dependency management with auto-detected targets.

Standalone Beez workflow plugin published by **coditary**.

## Features

- **Auto-detection**: Finds `Cargo.toml`, `src/main.rs`, `src/bin/*.rs` via `ctx.glob`
- **Optimized defaults**: Release builds use `cargo build --release`
- **Pipeline-compatible**: Standard phases and scopes (`app`, `debug`, `coverage`)
- **Polyglot-ready**: Works alongside Go/C++ plugins in mixed repositories

## Install

```lua
reqpack { beez = { { name = "coditary/cargo", version = "1.0.0", source = "github:Coditary/beez-cargo" } } }
```

## Usage

```lua
reqpack {
    beez = {
        { name = "coditary/cargo", version = "1.0.0" },
        { name = "coditary/pipeline", version = "1.0.0" },
    },
}

workflows({ build = "coditary/pipeline:build" })
configure({ { "coditary/cargo", {} } })
```

```bash
beez build
```

## Auto-detection

1. Finds nearest `Cargo.toml` (workspace root preferred)
2. Detects binaries from `src/main.rs` and `src/bin/*.rs`
3. Outputs to `target/release/<name>` or `target/debug/<name>`

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `configure:setup` | setup | app | `cargo fetch` |
| `compile:code` | compile | app | `cargo build --release` |
| `compile:debug` | compile | debug | `cargo build` |
| `bundle:code` | bundle | app | Verify release binaries |
| `test:unit` | test | test | `cargo test` |
| `test:coverage` | test | coverage | `cargo llvm-cov test` (if available) |

## Metadata

| Field | Value |
|-------|-------|
| Plugin ID | `coditary/cargo` |
| Version | `1.0.0` |

## License

Apache License 2.0.
