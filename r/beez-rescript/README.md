# rescript

ReScript compiler — `npm install`, `rescript build`, auto-detected projects.

Plugin ID: **`coditary/rescript`**

## Install

```lua
reqpack { beez = { { name = "coditary/rescript", version = "1.0.0", source = "github:Coditary/beez-rescript" } } }
```

## Usage

```lua
configure({ { "coditary/rescript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[rescript]
beez -s rescript:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `npx rescript build` | Output synced to `build/rescript/dist/` |
| bundle | verify dist | Checks `build/rescript/dist/**` or `*.res.js` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `rescript.json`, `package.json`, `**/*.res`, `**/*.resi`
- Entry points: `src/Main.res`, `src/App.res`, or first `src/*.res`

## License

Apache License 2.0.
