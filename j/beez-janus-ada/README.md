# janus-ada

**Janus Ada** — historical 1980s PC Ada compiler (`janusada` / `ada`) with auto-detected targets.

Plugin ID: **`coditary/janus-ada`**

> **Legacy notice:** Janus Ada is a discontinued, historical Ada 83 compiler originally
> developed by R.R. Software for CP/M and MS-DOS in the 1980s. It predates GNAT and targets
> 16-bit/32-bit PC environments with a separate compile-and-link workflow.
> Modern Ada projects should prefer [GNAT](https://www.adacore.com/gnat-pro) via `coditary/gnat`.
> This plugin exists for maintaining legacy codebases, historical builds, and retro computing only.

## Install

```lua
reqpack { beez = { { name = "coditary/janus-ada", version = "1.0.0", source = "github:Coditary/beez-janus-ada" } } }
```

## Usage

```lua
configure({ { "coditary/janus-ada", {} } })
workflows({ build = "coditary/janus-ada:build" })
```

```bash
beez build
beez -p compile[janus]
beez -s janus-ada:compile
```

## Detection

| Marker | Purpose |
|--------|---------|
| `**/*.ada` | Janus Ada source files (preferred extension) |
| `**/*.adb` | Ada body sources |
| `**/*.ads` | Ada spec sources |

Build targets are resolved from `main.ada`, `main.adb`, `src/main.adb`, and `cmd/*/main.adb`.
Release builds use `/O1 /3` (386 optimize). Output goes to `build/janus/bin/`.

Test programs are detected from `tests/**/*.adb`, `*_test.adb`, and `test_*.adb` patterns.

## Configuration

```lua
configure({
  { "coditary/janus-ada", {
      compiler_binary = "ada",   -- default: janusada
      janusada_binary = "janusada",
      ada_binary = "ada",
      link_binary = "link",
  }},
})
```

## Requirements

- `janusada` or `ada` (Janus Ada compiler) on `PATH`
- Optional: Microsoft `link` or Janus `jbind` for final executable linking

## License

Apache License 2.0.
