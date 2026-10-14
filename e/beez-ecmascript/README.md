# ecmascript

ECMAScript via Node/V8 — `node --check` with auto-detected `*.js` targets (no TypeScript).

Plugin ID: **`coditary/ecmascript`**

## Install

```lua
reqpack { beez = { { name = "coditary/ecmascript", version = "1.0.0", source = "github:Coditary/beez-ecmascript" } } }
```

## Usage

```lua
configure({ { "coditary/ecmascript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[ecmascript]
beez -s coditary/ecmascript:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `node` or `d8` | Creates `build/ecmascript/.ecmascript-setup` |
| compile | `node --check` / `d8 --check` | Validates `.js` sources, copies to `build/ecmascript/dist/` |
| bundle | verify dist | Checks `build/ecmascript/dist/**` |
| test | run primary entry | Executes `index.js` or first entry |

## Detection

- Markers: `**/*.js` (excludes TypeScript, `node_modules`, test files)
- Entry points: `src/index.js`, `src/main.js`, or first `src/*.js`
- Scope: `ecmascript`

## License

Apache License 2.0.
