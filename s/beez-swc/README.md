# swc

Official SWC (Speedy Web Compiler) plugin — transpiles TypeScript/JavaScript via `swc compile`.

Plugin ID: **`coditary/swc`**

## Install

```lua
reqpack { beez = { { name = "coditary/swc", version = "1.0.0", source = "github:Coditary/beez-swc" } } }
```

## Usage

```lua
configure({ { "coditary/swc", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[swc]
beez -s swc:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `swc compile src -d build/swc` | Uses `.swcrc` when present |
| bundle | verify output | Checks `build/swc/**` |
| test | `npm test` | Skipped when no `package.json` |

## Detection

- Markers: `.swcrc`, `package.json`, `**/*.ts`, `**/*.tsx`
- Source dir: `src/`, `lib/`, `app/`, or project root

## Configuration

```lua
configure({
  { "coditary/swc", {
    swc_binary = "npx @swc/cli",  -- or "swc" (default), or env SWC_BINARY
    source_dir = "src",
    extra_args = { "--strip-leading-paths" },
  }},
})
```

## License

Apache License 2.0.
