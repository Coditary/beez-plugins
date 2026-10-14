# tectonic

Official Tectonic compiler — Rust LaTeX engine with `Tectonic.toml` project support.

Plugin ID: **`coditary/tectonic`**

## Install

```lua
reqpack { beez = { { name = "coditary/tectonic", version = "1.0.0", source = "github:Coditary/beez-tectonic" } } }
```

## Usage

```lua
configure({ { "coditary/tectonic", {} } })
```

```bash
beez -p compile[tectonic]
beez -s tectonic:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `tectonic` | `tectonic --version` | Verifies Tectonic binary |
| compile | `tectonic` | `tectonic -X build` or `tectonic main.tex` | Uses `Tectonic.toml` when present |
| bundle | `tectonic` | verify PDF | Checks `build/tectonic/out/main.pdf` |
| test | `tectonic` | compile test `.tex` files | Skipped when no test files are detected |

## Detection

- Markers: `Tectonic.toml`, `**/*.tex`, `main.tex`
- Project mode: `Tectonic.toml` → `tectonic -X build --outdir build/tectonic/out`
- Single-file mode: `main.tex` or first root `*.tex`
- Tests: `tests/**/*.tex`, `test/**/*.tex`, `*_test.tex`

## License

Apache License 2.0.
