# icx

Intel ICX compile and link steps from compile_commands.json.

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/icx@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/icx",
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
beez build                    # icx:compile then icx:link
beez -s coditary/icx:icx:compile
beez -p compile[icx]
```

Set `CC=icx` and `CXX=icpx` (defaults) to override the compiler binaries used when replaying commands.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `icx:compile` | compile | icx | Compile sources from compile_commands.json |
| `icx:link` | bundle | icx | Link binaries under `bin/` |

## License

Apache-2.0 — see [LICENSE](LICENSE).
