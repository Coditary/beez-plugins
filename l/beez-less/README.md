# less

Official LESS plugin — compile stylesheets to CSS via lessc.

Plugin ID: **`coditary/less`**

## Install

```lua
reqpack { beez = { { name = "coditary/less", version = "1.0.0", source = "github:Coditary/beez-less" } } }
```

## Usage

```lua
configure({ { "coditary/less", {} } })
```

```bash
beez -p compile[less]
beez -s less:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `less` | `lessc --version` | Verifies LESS compiler |
| compile | `less` | `lessc --compress …` | Generates `build/less/bin/app.css` |
| bundle | `less` | verify output | Checks compiled CSS |
| test | `less` | compile test output | Validates stylesheet compilation |

## Detection

- Markers: `**/*.less`
- Entry point: first non-test stylesheet, or `entry_source` in configure()
- Output: compressed (code profile), expanded (debug profile)

## License

Apache License 2.0.
