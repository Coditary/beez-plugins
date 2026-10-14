# babel

Official Babel TypeScript/JavaScript transpiler — `@babel/preset-typescript` with auto-detected sources.

Plugin ID: **`coditary/babel`**

## Install

```lua
reqpack { beez = { { name = "coditary/babel", version = "1.0.0", source = "github:Coditary/beez-babel" } } }
```

## Usage

```lua
configure({ { "coditary/babel", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[babel]
beez -s babel:compile
```

Use `npx babel` when Babel is not on PATH:

```lua
configure({ { "coditary/babel", { use_npx = true } } })
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `babel src --out-dir build/babel --presets @babel/preset-typescript` | Output under `build/babel/` |
| bundle | verify artifacts | Checks `build/babel/` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `babel.config.js`, `babel.config.json`, `package.json`, `**/*.ts`, `**/*.tsx`
- Source dirs: `src/`, `lib/`, `app/`, or project root
- Scope: `babel` (release), `debug` (source maps)

## License

Apache License 2.0.
