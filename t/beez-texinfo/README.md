# texinfo

Official GNU Texinfo documentation plugin — `makeinfo` HTML with auto-detected entry point.

Plugin ID: **`coditary/texinfo`**

## Install

```lua
reqpack { beez = { { name = "coditary/texinfo", version = "1.0.0", source = "github:Coditary/beez-texinfo" } } }
```

## Usage

```lua
configure({ { "coditary/texinfo", {} } })
```

```bash
beez -p compile[texinfo]
beez -s texinfo:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `texinfo` | `makeinfo --version` | Verifies makeinfo binary |
| compile | `texinfo` | `makeinfo --html -o …` | Builds `build/texinfo/out/index.html` |
| bundle | `texinfo` | verify output | Checks generated HTML index |
| test | `test` | `makeinfo --check` | Validates Texinfo source |

## Detection

- Markers: `**/*.texi`, `**/*.texinfo`
- Entry points: `main.texi`, `index.texi`, `manual.texi`, or first root document

## License

Apache License 2.0.
