# oxygene

RemObjects **Oxygene Pascal** (Elements compiler) with auto-detected `.elements` / `.oxygene` / `.pas` targets.

Plugin ID: **`coditary/oxygene`**

> Supports .NET, Java, Android, and Swift targets via the RemObjects Elements toolchain. Requires `msbuild` and/or the `Elements` compiler on `PATH`, or configured explicitly in `build.lua`.

## Install

```lua
reqpack { beez = { { name = "coditary/oxygene", version = "1.0.0", source = "github:Coditary/beez-oxygene" } } }
```

Local development:

```lua
reqpack { beez = { { name = "coditary/oxygene", path = ".", version = "1.0.0" } } }
```

## Usage

```lua
configure({ { "coditary/oxygene", {} } })
```

```bash
beez -p setup[oxygene]
beez -p compile[oxygene]
beez -p bundle[oxygene]
beez -p test[oxygene]
```

Or run individual steps:

```bash
beez -s coditary/oxygene:compile:code
beez -s oxygene:compile:debug
```

## Auto-detection

| Marker | Role |
|--------|------|
| `*.elements`, `**/*.elements` | Elements project — built via `msbuild` |
| `*.oxygene`, `**/*.oxygene` | Oxygene project — built via `msbuild` |
| `*.pas`, `**/*.pas` | Pascal source inputs (cache invalidation; direct `Elements` compile when no project) |

Build artifacts are written to **`build/oxygene/bin/`**; intermediate files go to **`build/oxygene/obj/`**.

## Configuration

```lua
configure({
  { "coditary/oxygene", {
    msbuild_binary = "msbuild",
    elements_binary = "Elements",
    elements_target = ".NET",        -- .NET, Java, Android, Swift, …
    platform = "Any CPU",
    project_file = "src/MyApp.elements",
    test_elements = "tests/MyAppTests.elements",
    unit_paths = { "lib", "vendor" },
  }},
})
```

Environment variables:

| Variable | Purpose |
|----------|---------|
| `REPORTS_DIR` | Override test report directory (default: `report`) |

## Toolchain selection

- **`.elements` / `.oxygene` present** → `msbuild` with `OutputPath` / `OutDir` pointing to Beez output dirs
- **`.pas` sources only** → direct `Elements` compiler invocation
- **Tests** → `*Test.elements` / `*Tests.elements` auto-detected; otherwise a success stamp is written

## Requirements

- RemObjects Elements / Oxygene toolchain installed
- `msbuild` on `PATH` when building project files
- `Elements` compiler on `PATH` for plain-source builds

## License

Apache License 2.0.
