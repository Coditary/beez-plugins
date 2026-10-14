# gnustep-objc

GNUstep Objective-C compile and link steps from `compile_commands.json` (Linux/Windows).

Uses `gcc -x objective-c` with GNUstep flags from `gnustep-config`, or override with `CC`/`CXX` (e.g. `clang`).

## Install

From the Beez plugin catalog:

```bash
rqp install beez coditary/gnustep-objc@1.0.0
```

From this directory via `build.lua`:

```lua
reqpack {
  beez = {
    {
      name = "coditary/gnustep-objc",
      version = "1.0.0",
      path = ".",
    },
  },
}
```

Then: `beez --install`

## Usage

Requires a build tree with `compile_commands.json` under `build/gnustep-objc/` or at the project root.
GNUstep projects are detected via `**/*.m`, `GNUmakefile`, and `**/*.h`.

```bash
beez build                              # setup → compile → bundle → test
beez -s coditary/gnustep-objc:gnustep-objc:setup
beez -p compile[gnustep]
beez -p bundle[gnustep]
beez -p test[test]
```

By default the plugin resolves the compiler via `gnustep-config --objc-compiler`.
Set `use_gnustep_config = false` and `CC="clang -x objective-c"` to use Clang instead.

## Steps

| Step | Phase | Scope | Description |
|------|-------|-------|-------------|
| `gnustep-objc:setup` | setup | gnustep | Index `compile_commands.json` for GNUstep Objective-C |
| `gnustep-objc:compile` | compile | gnustep | Compile `.m`/`.mm` sources from index |
| `gnustep-objc:link` | bundle | gnustep | Link binaries under `build/gnustep-objc/bin/` |
| `gnustep-objc:test` | test | test | Run CTest in the GNUstep build tree |

## License

Apache-2.0 — see [LICENSE](LICENSE).
