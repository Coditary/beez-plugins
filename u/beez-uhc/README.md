# uhc

**Utrecht Haskell Compiler (UHC)** — experimental research Haskell compiler with auto-detected targets.

> **Experimental / research status:** UHC is an academic research compiler maintained at Utrecht University. Platform support is limited and unpredictable; Cabal/Stack integration is incomplete. Use for experimentation only — not recommended for production builds.

Plugin ID: **`coditary/uhc`**

## Install

```lua
reqpack { beez = { { name = "coditary/uhc", version = "1.0.0", source = "github:Coditary/beez-uhc" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/uhc", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/uhc", {} } })
workflows({ build = "coditary/uhc:build" })
```

```bash
beez build
beez -p compile[uhc]
beez -s coditary/uhc:compile:code
```

## Project layout

UHC projects are detected via Haskell source markers:

| Marker | Purpose |
|--------|---------|
| `**/*.hs` | Haskell source files |
| `*.uhi` | UHC interface files |

Entry points are resolved automatically: `Main.hs`, `src/Main.hs`, or the first non-test `*.hs` file.

Build output goes to **`build/uhc/bin/`**.

## Configuration

```lua
configure({
    { "coditary/uhc", {
        uhc_binary = "uhc",
        entry_point = "src/Main.hs",
        import_paths = { "lib" },
        output_name = "myapp",
    }},
})
```

## Steps

| Phase | Scope | Description |
|-------|-------|-------------|
| `setup[uhc]` | `uhc` | Verify UHC and prepare directories |
| `compile[uhc]` | `uhc` | Compile Haskell sources |
| `bundle[uhc]` | `uhc` | Verify build artifacts |
| `test[uhc]` | `uhc` | Compile test modules (`tests/`, `*_test.hs`) |

## Requirements

Install UHC from [UU-ComputerScience/uhc](https://github.com/UU-ComputerScience/uhc) or Hackage (`uhc-light`). See the [UHC wiki](http://www.cs.uu.nl/wiki/UHC/WebHome) for platform notes.

## License

Apache License 2.0.
