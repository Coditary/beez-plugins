# asymptote

Official Asymptote plugin — render vector graphics from `*.asy` sources via `asy`.

Plugin ID: **`coditary/asymptote`**

## Install

```lua
reqpack { beez = { { name = "coditary/asymptote", version = "1.0.0", source = "github:Coditary/beez-asymptote" } } }
```

## Usage

```lua
configure({ { "coditary/asymptote", {} } })
```

```bash
beez -p compile[asymptote]
beez -s asymptote:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `asymptote` | `asy --version` | Verifies Asymptote binary |
| compile | `asymptote` | `asy -f png -o …` | Generates `build/asymptote/bin/app.png` |
| bundle | `asymptote` | verify output | Checks rendered graphic |
| test | `asymptote` | render test output | Validates Asymptote rendering |

## Detection

- Markers: `**/*.asy`
- Entry point: first non-test `.asy` file, or `entry_source` in configure()
- Formats: PNG (code profile), SVG (debug profile)

## License

Apache License 2.0.
