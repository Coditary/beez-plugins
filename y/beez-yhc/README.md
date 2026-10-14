# yhc

**YHC / LHC Haskell compilers** — Yale Haskell Compiler and LLVM Haskell Compiler with auto-detected `.hs` and `.cabal` projects.

> **Experimental / alternative status:** [YHC](https://github.com/york-yorkie/yhc) (York Haskell Compiler) and
> [LHC](https://github.com/LHC/haskell-lhc) (LLVM Haskell Compiler) are alternative, research-oriented Haskell
> compilers with limited platform support and incomplete Cabal/Stack integration. Language extensions and library
> compatibility differ significantly from GHC. Use for experimentation, research, or maintaining niche codebases —
> not recommended for production builds. Modern Haskell projects should prefer
> [GHC](https://www.haskell.org/ghc/) with Cabal or Stack.

Plugin ID: **`coditary/yhc`**

## Install

```lua
reqpack { beez = { { name = "coditary/yhc", version = "1.0.0", source = "github:Coditary/beez-yhc" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/yhc", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/yhc", {} } })
workflows({ build = "coditary/yhc:build" })
```

```bash
beez build
beez -p compile[yhc]
beez -s coditary/yhc:compile:code
```

## Auto-detection

| Marker | Purpose |
|--------|---------|
| `**/*.hs` | Haskell source files |
| `*.cabal` | Package metadata and executable names |

Entry points are resolved from `Main.hs`, `src/Main.hs`, `app/Main.hs`, or per-executable paths. Build output goes to **`build/yhc/bin/`**.

## Compiler selection

Default compiler is **YHC**. Switch to LHC in `configure()` or via environment:

```lua
configure({ { "coditary/yhc", { compiler = "lhc" } } })
```

```bash
export YHC_COMPILER=lhc
export LHC_BINARY=lhc
beez build
```

## Configuration

```lua
configure({
    { "coditary/yhc", {
        compiler = "yhc",
        yhc_binary = "yhc",
        lhc_binary = "lhc",
        main_hs = "src/Main.hs",
        compiler_flags = "-O2",
    }},
})
```

## Steps

| Phase | Scope | Description |
|-------|-------|-------------|
| `setup[yhc]` | `yhc` | Verify YHC/LHC and prepare directories |
| `compile[yhc]` | `yhc` | Compile Haskell sources |
| `bundle[yhc]` | `yhc` | Verify build artifacts |
| `test[yhc]` | `yhc` | Compile and run test modules |

## Requirements

- `yhc` or `lhc` on `PATH` (alternative Haskell compiler toolchain)

## License

Apache License 2.0.
