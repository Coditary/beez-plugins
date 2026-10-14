# gnuplot

Official gnuplot plugin — render plotting scripts from `*.gp` and `*.gnuplot` files.

Plugin ID: **`coditary/gnuplot`**

## Install

```lua
reqpack { beez = { { name = "coditary/gnuplot", version = "1.0.0", source = "github:Coditary/beez-gnuplot" } } }
```

## Usage

```lua
configure({ { "coditary/gnuplot", {} } })
```

```bash
beez -p compile[gnuplot]
beez -s gnuplot:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `gnuplot` | `gnuplot --version` | Verifies gnuplot binary |
| compile | `gnuplot` | `gnuplot -e "set terminal …"` | Generates `build/gnuplot/bin/app.png` |
| bundle | `gnuplot` | verify output | Checks rendered plot |
| test | `gnuplot` | render test output | Validates gnuplot rendering |

## Detection

- Markers: `**/*.gp`, `**/*.gnuplot`
- Entry point: first non-test script file, or `entry_source` in configure()
- Terminals: PNG (code profile), SVG (debug profile)

## License

Apache License 2.0.
