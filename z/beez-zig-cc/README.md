# zig-cc

zig cc / zig c++ — drop-in GCC/Clang replacement for C/C++ cross-compilation.

Replays `compile_commands.json` from a Conan/CMake configure step, replacing the recorded compiler with `zig cc` or `zig c++`.

## Prerequisites

This plugin requires a configured CMake/Conan build tree with `compile_commands.json`. Run Conan configure first:

```bash
beez -s configure:setup
# or your project's configure workflow
```

Then compile and link with zig-cc:

```bash
beez build
```

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/zig-cc@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/zig-cc",
      version = "1.0.0",
      path = ".",
    },
    {
      name = "coditary/conan",
      version = "1.0.0",
    },
  },
}
```

Then: `beez --install`

## Usage

```bash
beez build                              # zig-cc:compile then zig-cc:link
beez -s coditary/zig-cc:zig-cc:compile
beez -p compile[zig-cc]
```

Default compilers: `CC="zig cc"`, `CXX="zig c++"`. Override via environment or `configure()`.

### Cross-compilation

Pass a Zig target triple in `configure()` — it is forwarded as `-target` on every compile and link command:

```lua
configure({
  { "coditary/conan", {} },
  { "coditary/zig-cc", {
    target = "aarch64-linux-gnu",
  }},
})
```

Examples: `x86_64-linux-gnu`, `aarch64-macos-none`, `wasm32-wasi`.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `zig-cc:compile` | compile | zig-cc | Compile sources from compile_commands.json |
| `zig-cc:link` | bundle | zig-cc | Link binaries under `bin/` |

## License

Apache-2.0 — see [LICENSE](LICENSE).
