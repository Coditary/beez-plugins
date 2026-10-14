# beez-clang

Monorepo of Clang-related Beez workflow plugins.

## Plugins

| Directory | Plugin ID |
|-----------|-----------|
| `clang/` | `coditary/clang` (Clang/LLVM compiler) |
| `clang-format/` | `coditary/clang-format` |
| `clang-tidy/` | `coditary/clang-tidy` |

Other C/C++ compilers are separate plugins: `coditary/gcc`, `coditary/msvc`, `coditary/icx`.

## Layout

```
beez-clang/
  clang/
    beez.package.json
    beez_plugin.lua
    src/
  clang-format/
  clang-tidy/
  releases/            # optional packaged .rqp + index.json (CI)
```

## Install

Catalog install (after `beez-registry` points clang plugins here):

```bash
rqp install beez coditary/clang-format@1.0.0
```

Explicit monorepo path:

```lua
source = "github:Coditary/beez-clang#clang-format"
```

## Bootstrap

Regenerate from the Beez monorepo:

```bash
cd ../Beez
lua scripts/ci/bootstrap_beez_clang_monorepo.lua --init-git
```

## Publish

1. Push to `https://github.com/Coditary/beez-clang`.
2. Tag a release and attach per-plugin indexes under `clang-format/index.json`, etc.
3. Run `lua scripts/ci/sync_plugin_catalog.lua` in Beez to refresh `beez-registry`.
