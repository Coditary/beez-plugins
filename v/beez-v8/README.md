# v8

V8 JavaScript JIT engine via Node.js (`node --check`) or standalone V8 shell (`d8 --check`).

Plugin ID: **`coditary/v8`**

## Install

```lua
reqpack { beez = { { name = "coditary/v8", version = "1.0.0", source = "github:Coditary/beez-v8" } } }
```

## Usage

```lua
configure({ { "coditary/v8", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[v8]
beez -s v8:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Verifies `node` or `d8`; skipped npm when no `package.json` |
| compile | `node --check` / `d8 --check` | Validates sources, copies to `build/v8/dist/` |
| bundle | verify dist | Checks `build/v8/dist/**` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `package.json`, `**/*.js`, `**/*.mjs`
- Entry points: `src/index.js`, `src/main.js`, or first `src/*.js`
- Scope: `v8`

## License

Apache License 2.0.
