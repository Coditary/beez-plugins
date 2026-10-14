# delphi

Embarcadero **Delphi** compiler (`dcc32` / `dcc64`) with auto-detected `.dproj` / `.dpr` targets.

Plugin ID: **`coditary/delphi`**

> **Windows-focused.** Delphi builds require Embarcadero RAD Studio or the standalone command-line compilers on Windows. `dcc32` (32-bit) and `dcc64` (64-bit) must be on `PATH`, or configured explicitly in `build.lua`.

## Install

```lua
reqpack { beez = { { name = "coditary/delphi", version = "1.0.0", source = "github:Coditary/beez-delphi" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/delphi", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/delphi", {} } })
```

```bash
beez -p setup[delphi]
beez -p compile[delphi]
beez -p bundle[delphi]
beez -p test[delphi]
```

Or run individual steps:

```bash
beez -s coditary/delphi:compile:code
beez -s delphi:compile:debug
```

## Auto-detection

| Marker | Role |
|--------|------|
| `*.dproj`, `**/*.dproj` | MSBuild project — built via `msbuild` |
| `*.dpr`, `**/*.dpr` | Delphi program — built via `dcc32` / `dcc64` |
| `**/*.pas` | Pascal source inputs (cache invalidation) |

Build artifacts are written to **`build/delphi/bin/`**; DCU files go to **`build/delphi/dcu/`**.

## Configuration

```lua
configure({
  { "coditary/delphi", {
    delphi_binary = "dcc32",       -- or "dcc64" for 64-bit
    delphi_arch = "64",              -- alternative: selects dcc64
    msbuild_binary = "msbuild",
    platform = "Win64",              -- Win32 (default) or Win64
    project_file = "src/MyApp.dproj",
    test_dproj = "tests/MyAppTests.dproj",
    unit_paths = { "lib", "vendor" },
  }},
})
```

Environment variables:

| Variable | Purpose |
|----------|---------|
| `DELPHI_ARCH` | Set to `64` to prefer `dcc64` |
| `REPORTS_DIR` | Override test report directory (default: `report`) |

## Toolchain selection

- **`.dproj` present** → `msbuild` with `DCC_ExeOutput` / `DCC_DcuOutput` pointing to Beez output dirs
- **`.dpr` only** → direct `dcc32` / `dcc64` invocation with `-E` / `-N` flags
- **Tests** → `*Test.dproj` / `*Tests.dproj` auto-detected; otherwise a success stamp is written

## Requirements

- Windows with Embarcadero RAD Studio (or Delphi command-line tools)
- `dcc32.exe` and/or `dcc64.exe` on `PATH`
- `msbuild.exe` on `PATH` when building `.dproj` files

On Linux/macOS, this plugin can be installed for polyglot project detection, but compile steps require a Windows host or cross-build environment with Delphi tooling available.

## License

Apache License 2.0.
