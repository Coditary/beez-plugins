# pharo

Official Pharo/Squeak Smalltalk plugin — headless VM compile and validate with auto-detected image and source files.

Plugin ID: **`coditary/pharo`**

## Install

```lua
reqpack { beez = { { name = "coditary/pharo", version = "1.0.0", source = "github:Coditary/beez-pharo" } } }
```

## Usage

```lua
configure({ { "coditary/pharo", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[pharo]
beez -s pharo:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `pharo` / `squeakvm` | Checks VM binary is on PATH |
| compile | headless Pharo | Runs `scripts/compile.st`, recompiles image, or fileIn `.st` sources |
| bundle | verify stamp | Checks `build/pharo/.compiled` |
| test | headless test runner | Uses `scripts/test.st` or `tests/run.st` when present |

## Detection

- Markers: `Pharo.image`, `*.image`, `**/*.st`
- Compile script: `scripts/compile.st` or `compile.st`
- Test script: `scripts/test.st`, `tests/run.st`, or `test.st`

## License

Apache License 2.0.
