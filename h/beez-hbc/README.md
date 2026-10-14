# hbc

**HBC / nhc98 Haskell compilers** — historical Haskell-98 compilers with auto-detected `.hs` sources.

Plugin ID: **`coditary/hbc`**

> **Legacy notice:** [HBC](https://en.wikipedia.org/wiki/HBC_(Haskell)) (Haskell Batch Compiler) and
> [nhc98](https://www.haskell.org/nhc98/) (Nottingham Haskell Compiler) are discontinued,
> historical Haskell-98 compilers from the 1990s–2000s. They predate Cabal/Stack and modern
> language extensions. Modern Haskell projects should prefer
> [GHC](https://www.haskell.org/ghc/) with Cabal or Stack.
> This plugin exists for maintaining legacy codebases and historical builds only.

## Install

```lua
reqpack { beez = { { name = "coditary/hbc", version = "1.0.0", source = "github:Coditary/beez-hbc" } } }
```

## Usage

```lua
configure({ { "coditary/hbc", {} } })
workflows({ build = "coditary/hbc:build" })
```

```bash
beez build
beez -p compile[hbc]
beez -s hbc:compile
```

### Using nhc98 instead of HBC

Set the compiler binary in `configure()` or via environment:

```lua
configure({ { "coditary/hbc", { hbc_binary = "nhc98" } } })
```

```bash
export HBC_BINARY=nhc98
beez build
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.hs` | Haskell-98 source |

Build targets are resolved from `Main.hs`, `main/Main.hs`, `src/Main.hs`, `cmd/*/Main.hs`, or all non-test sources. Output goes to `build/hbc/bin/`.

Test programs are detected from `tests/**`, `*Test*`, `*test*`, and `*_test` patterns.

## Requirements

- `hbc` or `nhc98` on `PATH` (historical Haskell-98 compiler)

## License

Apache License 2.0.
