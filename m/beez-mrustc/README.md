# mrustc

[mrustc](https://github.com/thepowersgang/mrustc) bootstrap Rust compiler — build Rust crates without an existing `rustc` toolchain.

Plugin ID: **`coditary/mrustc`**

## Bootstrap use case

mrustc is a C++ implementation of the Rust compiler used to bootstrap the official Rust toolchain from source. Typical workflows:

1. Build mrustc and its standard library (`libstd`) from the mrustc repository.
2. Point this plugin at your crate and a prebuilt `libstd` directory.
3. Compile Rust sources with mrustc instead of `rustc`/`cargo`.

This is useful when you need to compile Rust on systems without a Rust toolchain, or when bootstrapping rustc itself in a from-scratch build pipeline.

## Install

```lua
reqpack {
    beez = {
        {
            name = "coditary/mrustc",
            version = "1.0.0",
            source = "github:Coditary/beez-mrustc",
        },
    },
}
```

Local development:

```lua
reqpack {
    beez = {
        {
            name = "coditary/mrustc",
            path = ".",
            version = "1.0.0",
        },
    },
}
```

## Usage

```lua
configure({
    { "coditary/mrustc", {
        libstd_dir = "/path/to/mrustc/output",
        mrustc_binary = "mrustc",
    }},
})
workflows({ build = "coditary/mrustc:build" })
```

```bash
beez build
beez -s mrustc:compile
beez -p compile[mrustc]
```

## Steps

| Step | Description |
|------|-------------|
| `mrustc:configure` | Verify `mrustc` is available on `PATH` |
| `mrustc:compile` | Compile main crate via `mrustc --out-dir build/mrustc ...` |
| `mrustc:bundle` | Verify binaries under `build/mrustc/bin/` |
| `mrustc:test` | Run `minicargo test` when available, else smoke-test binary |

## Defaults

- Scope: `mrustc` (does not conflict with `coditary/cargo`)
- Output: `build/mrustc/bin/<target>`
- Auto-detects `Cargo.toml` and `src/main.rs` / `src/bin/*.rs` targets
- `libstd_dir` from config or `MRUSTC_LIBSTD_DIR` environment variable

## License

Apache License 2.0.
