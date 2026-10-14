# gcc

GCC compile and link steps from compile_commands.json.

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/gcc@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/gcc",
      version = "1.0.0",
      path = ".",
    },
  },
}
```

Then: `beez --install`

## Usage

Requires a configured CMake/Conan build tree with `compile_commands.json`.

```bash
beez build                    # gcc:compile then gcc:link
beez -s coditary/gcc:gcc:compile
beez -p compile[gcc]
```

Set `CC=gcc` and `CXX=g++` (defaults) to override the compiler binaries used when replaying commands.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `gcc:compile` | compile | gcc | Compile sources from compile_commands.json |
| `gcc:link` | bundle | gcc | Link binaries under `bin/` |

## License

Apache-2.0 — see [LICENSE](LICENSE).
