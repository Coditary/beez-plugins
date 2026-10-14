# remotion

Official Remotion plugin — render React/TypeScript video compositions to MP4 via `npx remotion render`.

Plugin ID: **`coditary/remotion`**

## Install

```lua
reqpack { beez = { { name = "coditary/remotion", version = "1.0.0", source = "github:Coditary/beez-remotion" } } }
```

## Usage

```lua
configure({ { "coditary/remotion", { composition_id = "Main" } } })
```

```bash
beez -p compile[remotion]
beez -s remotion:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `remotion` | `npx remotion versions` | Verifies Remotion CLI |
| compile | `remotion` | `npx remotion render … Main …` | Generates `build/remotion/bin/app.mp4` |
| bundle | `remotion` | verify output | Checks generated artifact |
| test | `remotion` | `npx remotion versions` | Validates project when test files exist |

## Detection

- Markers: `package.json` with remotion dependency, `**/*.{tsx,ts}`
- Entry point: `src/index.tsx`, `src/Root.tsx`, or `entry_source` in configure()
- Composition ID: defaults to `Main`, override via `composition_id` in configure()
- Tests: `**/*.test.ts(x)`, `**/*.spec.ts(x)`

## License

Apache License 2.0.
