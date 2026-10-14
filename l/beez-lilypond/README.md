# lilypond

Official LilyPond plugin — render music notation (`*.ly`) to PDF.

Plugin ID: **`coditary/lilypond`**

## Install

```lua
reqpack { beez = { { name = "coditary/lilypond", version = "1.0.0", source = "github:Coditary/beez-lilypond" } } }
```

## Usage

```lua
configure({ { "coditary/lilypond", {} } })
```

```bash
beez -p compile[lilypond]
beez -s lilypond:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `lilypond` | `lilypond --version` | Verifies LilyPond binary |
| compile | `lilypond` | `lilypond -o build/lilypond/bin/app …` | Generates `build/lilypond/bin/app.pdf` |
| bundle | `lilypond` | verify output | Checks generated PDF |
| test | `lilypond` | `lilypond --check …` | Syntax validation when test files exist |

## Detection

- Markers: `**/*.ly`
- Entry point: first non-test `*.ly`, or `entry_source` in configure()
- Tests: `test/**/*.ly`, `test_*.ly`, `*_test.ly`

## License

Apache License 2.0.
