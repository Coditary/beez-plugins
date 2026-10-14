# csound

Official Csound plugin — synthesize audio from orchestra/score sources (`*.csd`, `*.orc`, `*.sco`).

Plugin ID: **`coditary/csound`**

## Install

```lua
reqpack { beez = { { name = "coditary/csound", version = "1.0.0", source = "github:Coditary/beez-csound" } } }
```

## Usage

```lua
configure({ { "coditary/csound", {} } })
```

```bash
beez -p compile[csound]
beez -s csound:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `csound` | `csound --version` | Verifies Csound binary |
| compile | `csound` | `csound -W -d -o …` | Renders `build/csound/bin/app.wav` |
| bundle | `csound` | verify output | Checks rendered WAV |
| test | `csound` | render test output | Validates synthesis when test sources exist |

## Detection

- Markers: `**/*.csd`, `**/*.orc`, `**/*.sco`
- Entry point: first non-test `*.csd`, else first `*.orc`, or `entry_source` in configure()
- Score file: matching `*.sco` for `*.orc` entries, or `score_source` in configure()
- Tests: `test/**/*.csd`, `test/**/*.orc`

## License

Apache License 2.0.
