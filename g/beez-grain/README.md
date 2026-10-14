# grain

Official Grain compiler — Wasm-only output via `grain compile`, auto-detected `grain.json`.

Plugin ID: **`coditary/grain`**

## Install

```lua
reqpack { beez = { { name = "coditary/grain", version = "1.0.0", source = "github:Coditary/beez-grain" } } }
```

## Usage

```lua
configure({ { "coditary/grain", {} } })
```

```bash
beez -p compile[grain]
beez -s grain:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `grain` | `grain --version` | Verifies Grain compiler binary |
| compile | `grain` | `grain compile -o build/grain/bin/app.wasm` | WebAssembly output |
| bundle | `grain` | verify `.wasm` | Checks `build/grain/bin/app.wasm` |
| test | `grain` | `./run-tests` or `grain run` | Skipped when no test files are detected |

## Detection

- Markers: `grain.json`, `**/*.gr`
- Entry points: `main.gr`, `src/main.gr`, or first root `*.gr`
- Tests: `**/*.test.gr`, `**/*_test.gr`, `test/**/*.gr`, `tests/**/*.gr`

## License

Apache License 2.0.
