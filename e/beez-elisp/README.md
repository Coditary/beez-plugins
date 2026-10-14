# elisp

Official Emacs Lisp plugin — batch load check with auto-detected `*.el` targets.

Plugin ID: **`coditary/elisp`**

## Install

```lua
reqpack { beez = { { name = "coditary/elisp", version = "1.0.0", source = "github:Coditary/beez-elisp" } } }
```

## Usage

```lua
configure({ { "coditary/elisp", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[elisp]
beez -s coditary/elisp:compile:code
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `emacs` | Creates `build/elisp/.elisp-setup` |
| compile | `emacs --batch -l` | Batch-loads all non-test `.el` files |
| bundle | verify compile stamp | Checks `build/elisp/.elisp-compile-*` |
| test | run primary file | Loads `main.el` or first entry in batch |

## Detection

- Markers: `**/*.el`
- Entry points: `main.el`, or first non-test file
- Binary: `emacs` (override with `EMACS` env or `emacs_binary` config)

## License

Apache License 2.0.
