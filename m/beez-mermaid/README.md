# mermaid

Official Mermaid CLI plugin — render diagrams (`*.mmd`, `*.mermaid`) to PNG via `mmdc`.

Plugin ID: **`coditary/mermaid`**

## Install

```lua
reqpack { beez = { { name = "coditary/mermaid", version = "1.0.0", source = "github:Coditary/beez-mermaid" } } }
```

## Usage

```lua
configure({ { "coditary/mermaid", {} } })
```

```bash
beez -p compile[mermaid]
beez -s mermaid:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `mermaid` | `mmdc --version` | Verifies Mermaid CLI binary |
| compile | `mermaid` | `mmdc -i … -o …` | Generates `build/mermaid/bin/app.png` |
| bundle | `mermaid` | verify output | Checks generated PNG |
| test | `mermaid` | `mmdc -i … -o test-render.png` | Re-render validation when test files exist |

## Detection

- Markers: `**/*.mmd`, `**/*.mermaid`
- Entry point: first non-test diagram file, or `entry_source` in configure()
- Tests: `test/**/*.mmd`, `test_*.mmd`, `*_test.mmd` (and `.mermaid` variants)

## License

Apache License 2.0.
