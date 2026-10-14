# manim

Official Manim plugin — render Python mathematical animation scenes to MP4.

Plugin ID: **`coditary/manim`**

## Install

```lua
reqpack { beez = { { name = "coditary/manim", version = "1.0.0", source = "github:Coditary/beez-manim" } } }
```

## Usage

```lua
configure({ { "coditary/manim", {} } })
```

```bash
beez -p compile[manim]
beez -s manim:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `manim` | `manim --version` | Verifies Manim CLI binary |
| compile | `manim` | `manim -ql … SceneClass` | Generates `build/manim/bin/app.mp4` |
| bundle | `manim` | verify output | Checks generated artifact |
| test | `manim` | dry-run render | Validates scene sources when test files exist |

## Detection

- Markers: `**/*.py` with manim imports (`from manim import`, `import manim`), `scenes/`
- Entry point: first scene in `scenes/`, or first manim *.py, or `entry_source` / `scene_class` in configure()
- Tests: `test/**/*.py`, `test_*.py`, `*_test.py`

## License

Apache License 2.0.
