# seqdiag

Official seqdiag plugin — render sequence diagrams from `*.seqdiag` sources.

Plugin ID: **`coditary/seqdiag`**

## Install

```lua
reqpack { beez = { { name = "coditary/seqdiag", version = "1.0.0", source = "github:Coditary/beez-seqdiag" } } }
```

## Usage

```lua
configure({ { "coditary/seqdiag", {} } })
```

```bash
beez -p compile[seqdiag]
beez -s seqdiag:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `seqdiag` | `seqdiag --version` | Verifies seqdiag binary |
| compile | `seqdiag` | `seqdiag -Tpng -o …` | Generates `build/seqdiag/bin/app.png` |
| bundle | `seqdiag` | verify output | Checks rendered diagram |
| test | `seqdiag` | render test output | Validates seqdiag sources |

## Detection

- Markers: `**/*.seqdiag`, `**/*seqdiag*`
- Entry point: first matching sequence diagram file, or `entry_source` in configure()

## License

Apache License 2.0.
