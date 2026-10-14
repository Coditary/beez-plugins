# ink

Official Inkle Ink plugin — compile interactive narrative `.ink` sources to JSON via `inklecate`.

Plugin ID: **`coditary/ink`**

## Install

```lua
reqpack { beez = { { name = "coditary/ink", version = "1.0.0", source = "github:Coditary/beez-ink" } } }
```

## Usage

```lua
configure({ { "coditary/ink", {} } })
```

```bash
beez -p compile[ink]
beez -s ink:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ink` | `inklecate -v` | Verifies inklecate binary |
| compile | `ink` | `inklecate -o story.json …` | Generates JSON in `build/ink/bin/` |
| bundle | `ink` | verify output | Checks JSON story artifact |
| test | `ink` | compile test stories | Validates Ink compilation |

## Detection

- Markers: `**/*.ink`
- Entry point: `main.ink`, `story.ink`, `index.ink`, or first non-test `.ink` file
- Output: `build/ink/bin/story.json`

## License

Apache License 2.0.
