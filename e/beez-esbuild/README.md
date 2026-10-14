# esbuild

Official esbuild plugin — bundles and transpiles TypeScript/JavaScript with auto-detected entry points.

Plugin ID: **`coditary/esbuild`**

## Install

```lua
reqpack { beez = { { name = "coditary/esbuild", version = "1.0.0", source = "github:Coditary/beez-esbuild" } } }
```

## Usage

```lua
configure({ { "coditary/esbuild", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[esbuild]
beez -s esbuild:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `esbuild --bundle --minify` | Output under `build/esbuild/` |
| bundle | verify bundles | Checks `build/esbuild/*.js` |
| test | `npm test` | Uses npm test script when available |

## Detection

- Markers: `package.json`, `**/*.ts`, `**/*.tsx`, `**/*.js`
- Entry points: `package.json` main/module, `src/index.ts`, `index.js`, or first `src/*.{ts,tsx,js}`
- Binary: `esbuild` with fallback to `npx esbuild`

## License

Apache License 2.0.
