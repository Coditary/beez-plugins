# ghc

Glasgow Haskell Compiler (**GHC**) — de-facto standard Haskell compiler with Cabal, Stack, or direct `ghc` invocation.

Plugin ID: **`coditary/ghc`**

## Install

```lua
reqpack { beez = { { name = "coditary/ghc", version = "1.0.0", source = "github:Coditary/beez-ghc" } } }
```

## Usage

```lua
configure({ { "coditary/ghc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Auto-detection

| Marker | Build tool | Setup | Compile |
|--------|------------|-------|---------|
| `stack.yaml` | Stack | `stack setup` | `stack build` + install to `build/ghc/bin/` |
| `*.cabal` | Cabal | `cabal update` | `cabal build` → `dist-newstyle`, install to `build/ghc/bin/` |
| `**/*.hs` (Main.hs) | GHC | version check | `ghc -o build/ghc/bin/<name> Main.hs` |

## Output

- Binaries: `build/ghc/bin/`
- Cabal build tree: `dist-newstyle/`

## License

Apache License 2.0.
