# pollen

Official Pollen Racket publishing compiler — `raco pollen render` with auto-detected `.pmd` entry point.

Plugin ID: **`coditary/pollen`**

## Install

```lua
reqpack { beez = { { name = "coditary/pollen", version = "1.0.0", source = "github:Coditary/beez-pollen" } } }
```

## Usage

```lua
configure({ { "coditary/pollen", {} } })
```

```bash
beez -p compile[pollen]
beez -s pollen:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `pollen` | `raco pollen version` | Verifies Pollen toolchain |
| compile | `pollen` | `raco pollen render index.pmd` | Renders Pollen to HTML/PDF |
| bundle | `pollen` | verify output | Checks `build/pollen/out/` artifacts |
| test | `pollen` | render test `.pmd` files | Skipped when no test files are detected |

## Detection

- Markers: `**/*.pmd`, `pollen.rkt`
- Entry points: `index.pmd`, `main.pmd`, or first root `*.pmd`
- Tests: `tests/**/*.pmd`, `test/**/*.pmd`, `*_test.pmd`

## License

Apache License 2.0.
