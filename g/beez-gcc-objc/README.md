# gcc-objc

GCC Objective-C frontend — compile and link steps from `compile_commands.json`.

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/gcc-objc@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/gcc-objc",
      version = "1.0.0",
      path = ".",
    },
  },
}
```

Then: `beez --install`

## Usage

Requires a configured CMake/Conan build tree with `compile_commands.json` under `build/gcc-objc/`.

```bash
beez build                         # setup → compile → bundle → test
beez -s coditary/gcc-objc:gcc-objc:compile
beez -p compile[gcc-objc]
```

Set `CC="gcc -x objective-c"` and `CXX=g++` (defaults) to override the compiler binaries used when replaying commands.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `configure:setup` | setup | gcc-objc | Verify toolchain and index compile_commands.json |
| `gcc-objc:compile` | compile | gcc-objc | Compile Objective-C sources from compile_commands.json |
| `gcc-objc:link` | bundle | gcc-objc | Link binaries under `build/gcc-objc/bin/` |
| `test:unit` | test | gcc-objc | Run CTest in the build tree |

## License

Apache-2.0 — see [LICENSE](LICENSE).
