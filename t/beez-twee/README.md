# twee

Official Twee/Twine plugin — compile interactive fiction `.twee`/`.tw` sources to HTML via the `twee` compiler.

Plugin ID: **`coditary/twee`**

## Install

```lua
reqpack { beez = { { name = "coditary/twee", version = "1.0.0", source = "github:Coditary/beez-twee" } } }
```

## Usage

```lua
configure({ { "coditary/twee", {} } })
```

```bash
beez -p compile[twee]
beez -s twee:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `twee` | `twee --version` | Verifies Twee compiler |
| compile | `twee` | `twee -o app.html …` | Generates HTML in `build/twee/bin/` |
| bundle | `twee` | verify output | Checks HTML artifact |
| test | `twee` | compile test stories | Validates Twee compilation |

## Detection

- Markers: `**/*.twee`, `**/*.tw`
- Entry point: `main.twee`, `story.twee`, or first non-test source file
- Output: `build/twee/bin/app.html`

## License

Apache License 2.0.
