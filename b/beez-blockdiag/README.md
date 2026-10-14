# blockdiag

Official blockdiag plugin — render Python network topology diagrams from `*.diag` sources.

Plugin ID: **`coditary/blockdiag`**

## Install

```lua
reqpack { beez = { { name = "coditary/blockdiag", version = "1.0.0", source = "github:Coditary/beez-blockdiag" } } }
```

## Usage

```lua
configure({ { "coditary/blockdiag", {} } })
```

```bash
beez -p compile[blockdiag]
beez -s blockdiag:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `blockdiag` | `blockdiag --version` | Verifies blockdiag binary |
| compile | `blockdiag` | `blockdiag -Tpng -o …` | Generates `build/blockdiag/bin/app.png` |
| bundle | `blockdiag` | verify output | Checks rendered diagram |
| test | `blockdiag` | render test output | Validates blockdiag sources |

## Detection

- Markers: `**/*.diag`, `**/*blockdiag*`
- Entry point: first matching `*blockdiag*.diag`, then first non-test `*.diag`, or `entry_source` in configure()

## License

Apache License 2.0.
