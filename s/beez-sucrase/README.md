# sucrase

Sucrase fast TypeScript/JavaScript transpiler — `npm install`, directory transpile (no typecheck), auto-detected sources.

Plugin ID: **`coditary/sucrase`**

## Install

```lua
reqpack { beez = { { name = "coditary/sucrase", version = "1.0.0", source = "github:Coditary/beez-sucrase" } } }
```

## Usage

```lua
configure({ { "coditary/sucrase", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[sucrase]
beez -s sucrase:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `sucrase` / `npx sucrase` | Output under `build/sucrase/` |
| bundle | verify dist | Checks `build/sucrase/**` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `package.json`, `**/*.ts`, `**/*.tsx`
- Source dirs: `src/`, `lib/`, `app/`, or project root

## License

Apache License 2.0.
