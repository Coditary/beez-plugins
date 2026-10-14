# asterius

**Asterius** — Haskell-to-WebAssembly compiler using `ahc-link`, `ahc-cabal`, and `ahc-dist`.

Plugin ID: **`coditary/asterius`**

## Install

```lua
reqpack { beez = { { name = "coditary/asterius", version = "1.0.0", source = "github:Coditary/beez-asterius" } } }
```

## Usage

```lua
configure({ { "coditary/asterius", {} } })
workflows({ wasm = "coditary/asterius:wasm" })
```

```bash
beez wasm
beez -p compile[wasm]
beez -s coditary/asterius:compile:wasm
```

## Auto-detection

| Marker | Build tool | Setup | Compile |
|--------|------------|-------|---------|
| `stack.yaml` / `*.cabal` | ahc-cabal | `ahc-cabal new-update` | `ahc-cabal build` → `ahc-dist` → `build/asterius/wasm/` |
| `**/*.hs` (Main.hs) | ahc-link | version check | `ahc-link --input-hs Main.hs --output-dir=build/asterius/wasm/` |

## Output

- WebAssembly artifacts: `build/asterius/wasm/`
- Cabal pseudo-executables (intermediate): `build/asterius/pseudo-exe/`

## License

Apache License 2.0.
