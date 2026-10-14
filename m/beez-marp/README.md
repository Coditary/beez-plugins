# marp

Official Marp CLI plugin — render Markdown slide decks (`*.md` with Marp frontmatter) to PDF or HTML.

Plugin ID: **`coditary/marp`**

## Install

```lua
reqpack { beez = { { name = "coditary/marp", version = "1.0.0", source = "github:Coditary/beez-marp" } } }
```

## Usage

```lua
configure({ { "coditary/marp", {} } })
```

```bash
beez -p compile[marp]
beez -s marp:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `marp` | `marp --version` | Verifies Marp CLI binary |
| compile | `marp` | `marp --pdf -o … …` | Generates `build/marp/bin/app.pdf` |
| bundle | `marp` | verify output | Checks generated artifact |
| test | `marp` | re-render to HTML | Validates slide sources when test files exist |

## Detection

- Markers: `**/*.md` with Marp frontmatter (`marp:`, `<!-- marp -->`)
- Entry point: first non-test Marp markdown file, or `entry_source` in configure()
- Tests: `test/**/*.md`, `test_*.md`, `*_test.md`

## License

Apache License 2.0.
