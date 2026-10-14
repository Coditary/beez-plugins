# remarkjs

Official remark.js plugin — render Markdown slide decks (`*.md` with remark frontmatter) to standalone HTML.

Plugin ID: **`coditary/remarkjs`**

## Install

```lua
reqpack { beez = { { name = "coditary/remarkjs", version = "1.0.0", source = "github:Coditary/beez-remarkjs" } } }
```

## Usage

```lua
configure({ { "coditary/remarkjs", {} } })
```

```bash
beez -p compile[remarkjs]
beez -s remarkjs:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `remarkjs` | `remark --version` | Verifies remark.js CLI binary |
| compile | `remarkjs` | `remark -o … …` | Generates `build/remarkjs/bin/app.html` |
| bundle | `remarkjs` | verify output | Checks generated HTML |
| test | `remarkjs` | re-render to HTML | Validates slide sources when test files exist |

## Detection

- Markers: `**/*.md` with remark.js frontmatter (`class: remark`, `count: true`, etc.)
- Entry point: first non-test remark markdown file, or `entry_source` in configure()
- Tests: `test/**/*.md`, `test_*.md`, `*_test.md`

## License

Apache License 2.0.
