# graphviz

Official Graphviz plugin — render DOT/GV graphs via dot or neato layout engines.

Plugin ID: **`coditary/graphviz`**

## Install

```lua
reqpack { beez = { { name = "coditary/graphviz", version = "1.0.0", source = "github:Coditary/beez-graphviz" } } }
```

## Usage

```lua
configure({ { "coditary/graphviz", {} } })
```

```bash
beez -p compile[graphviz]
beez -s graphviz:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `graphviz` | `dot -V` | Verifies Graphviz binary |
| compile | `graphviz` | `dot -Tpng -o …` | Generates `build/graphviz/bin/app.png` |
| bundle | `graphviz` | verify output | Checks rendered graph |
| test | `graphviz` | render test output | Validates graph rendering |

## Detection

- Markers: `**/*.dot`, `**/*.gv`
- Entry point: first non-test graph file, or `entry_source` in configure()
- Layout: `dot` (code profile), `neato` (debug profile)

## License

Apache License 2.0.
