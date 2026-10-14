# mdbook

Official mdbook Rust web book plugin — `mdbook build` with auto-detected `book.toml`.

Plugin ID: **`coditary/mdbook`**

## Install

```lua
reqpack { beez = { { name = "coditary/mdbook", version = "1.0.0", source = "github:Coditary/beez-mdbook" } } }
```

## Usage

```lua
configure({ { "coditary/mdbook", {} } })
```

```bash
beez -p compile[mdbook]
beez -s mdbook:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `mdbook` | `mdbook --version` | Verifies mdbook binary |
| compile | `mdbook` | `mdbook build --dest-dir …` | Builds `build/mdbook/html/index.html` |
| bundle | `mdbook` | verify output | Checks generated HTML index |
| test | `test` | `mdbook test` | Validates Rust code blocks in book |

## Detection

- Markers: `book.toml`, `**/*.md`
- Book dir: directory containing `book.toml`
- Tests: markdown sources under `src/` or test directories

## License

Apache License 2.0.
