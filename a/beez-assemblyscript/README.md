# assemblyscript

AssemblyScript (TypeScript subset to Wasm) — `npm install`, `asc` compile, auto-detected projects.

Plugin ID: **`coditary/assemblyscript`**

## Install

```lua
reqpack { beez = { { name = "coditary/assemblyscript", version = "1.0.0", source = "github:Coditary/beez-assemblyscript" } } }
```

## Usage

```lua
configure({ { "coditary/assemblyscript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[wasm]
beez -s assemblyscript:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `npx asc` | Output under `build/assemblyscript/wasm/` |
| bundle | verify wasm | Checks `build/assemblyscript/wasm/*.wasm` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `asconfig.json`, `package.json`, `**/*.ts`
- Entry points: `assembly/index.ts`, `index.ts`, or first `assembly/*.ts`

## License

Apache License 2.0.
