# tsc

Official TypeScript compiler (Microsoft `tsc`) — `npm install`, `tsc` compile, auto-detected projects.

Plugin ID: **`coditary/tsc`**

## Install

```lua
reqpack { beez = { { name = "coditary/tsc", version = "1.0.0", source = "github:Coditary/beez-tsc" } } }
```

## Usage

```lua
configure({ { "coditary/tsc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `npx tsc` | Output under `build/tsc/dist/` |
| bundle | verify dist | Checks `build/tsc/dist/**` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `tsconfig.json`, `package.json`, `**/*.ts`, `**/*.tsx`
- Entry points: `src/index.ts`, `src/main.ts`, or first `src/*.ts`

## License

Apache License 2.0.
