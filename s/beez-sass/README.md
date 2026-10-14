# sass

Official Sass/SCSS plugin — compile stylesheets to CSS via the Dart Sass compiler.

Plugin ID: **`coditary/sass`**

## Install

```lua
reqpack { beez = { { name = "coditary/sass", version = "1.0.0", source = "github:Coditary/beez-sass" } } }
```

## Usage

```lua
configure({ { "coditary/sass", {} } })
```

```bash
beez -p compile[sass]
beez -s sass:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `sass` | `sass --version` | Verifies Sass binary |
| compile | `sass` | `sass --style=compressed …` | Generates `build/sass/bin/app.css` |
| bundle | `sass` | verify output | Checks compiled CSS |
| test | `sass` | compile test output | Validates stylesheet compilation |

## Detection

- Markers: `**/*.scss`, `**/*.sass`
- Entry point: first non-test stylesheet, or `entry_source` in configure()
- Style: `compressed` (code profile), `expanded` (debug profile)

## License

Apache License 2.0.
