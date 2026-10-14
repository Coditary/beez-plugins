# revealjs

Official reveal.js plugin — render Markdown slide decks (`*.md` with reveal config) to static HTML via `reveal-md`.

Plugin ID: **`coditary/revealjs`**

## Install

```lua
reqpack { beez = { { name = "coditary/revealjs", version = "1.0.0", source = "github:Coditary/beez-revealjs" } } }
```

## Usage

```lua
configure({ { "coditary/revealjs", {} } })
```

```bash
beez -p compile[revealjs]
beez -s revealjs:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `revealjs` | `reveal-md --version` | Verifies reveal-md binary |
| compile | `revealjs` | `reveal-md --static … …` | Generates `build/revealjs/bin/index.html` |
| bundle | `revealjs` | verify output | Checks generated HTML |
| test | `revealjs` | static re-render | Validates slide sources when test files exist |

## Detection

- Markers: `**/*.md` with reveal.js config (`theme:`, `transition:`, `data-background`, etc.)
- Entry point: first non-test reveal markdown file, or `entry_source` in configure()
- Tests: `test/**/*.md`, `test_*.md`, `*_test.md`

## License

Apache License 2.0.
