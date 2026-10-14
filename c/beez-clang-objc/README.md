# clang-objc

Clang/LLVM compile and link steps for Objective-C from `compile_commands.json` (Xcode toolchain).

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/clang-objc@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/clang-objc",
      version = "1.0.0",
      path = ".",
    },
  },
}
```

Then: `beez --install`

## Usage

Requires a CMake build tree with `compile_commands.json` under `build/clang-objc/` or at the project root.

```bash
beez build                              # setup → compile → bundle → test
beez -s coditary/clang-objc:clang-objc:setup
beez -p compile[objc]
beez -p bundle[objc]
beez -p test[test]
```

Set `CC="clang -x objective-c"` and `CXX=clang++` (defaults) to override compiler binaries when replaying commands.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `clang-objc:setup` | setup | objc | Index `compile_commands.json` for Objective-C |
| `clang-objc:compile` | compile | objc | Compile `.m`/`.mm` sources from index |
| `clang-objc:link` | bundle | objc | Link binaries under `build/clang-objc/bin/` |
| `clang-objc:test` | test | test | Run CTest in the Objective-C build tree |

## License

Apache-2.0 — see [LICENSE](LICENSE).
