# style-dictionary

Official Style Dictionary plugin — Amazon design token compiler to CSS, SCSS, JSON, and more.

Plugin ID: **`coditary/style-dictionary`**

## Install

```lua
reqpack { beez = { { name = "coditary/style-dictionary", version = "1.0.0", source = "github:Coditary/beez-style-dictionary" } } }
```

## Usage

```lua
configure({ { "coditary/style-dictionary", {} } })
```

```bash
beez -p compile[style-dictionary]
beez -s style-dictionary:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `style-dictionary` | `npm install` | Installs token dependencies |
| compile | `style-dictionary` | `npx style-dictionary build` | Generates token outputs |
| bundle | `style-dictionary` | verify output | Checks build artifacts |
| test | `style-dictionary` | `npm test` | Validates token build |

## Detection

- Markers: `style-dictionary.config.js/json`, `config.json` with style-dictionary, `**/tokens/**/*.json`
- Config: auto-detected Style Dictionary config or `config_path` in configure()
- Binary: `style-dictionary` (fallback `npx --yes style-dictionary`)

## License

Apache License 2.0.
