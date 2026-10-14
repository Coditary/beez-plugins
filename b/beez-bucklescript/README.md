# bucklescript

BuckleScript compiler plugin — `npm install`, `bsb -make-world`, auto-detected projects.

Plugin ID: **`coditary/bucklescript`**

> **Historical note:** BuckleScript was the original OCaml/Reason-to-JavaScript compiler. The project merged into [ReScript](https://rescript-lang.org/) in 2020. Use this plugin for legacy BuckleScript projects (`bsconfig.json`, `bsb`, `bsb-native`). For new projects, prefer `coditary/rescript`.

## Install

```lua
reqpack { beez = { { name = "coditary/bucklescript", version = "1.0.0", source = "github:Coditary/beez-bucklescript" } } }
```

## Usage

```lua
configure({ { "coditary/bucklescript", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[bucklescript]
beez -s bucklescript:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `npm install` | Skipped when no `package.json` |
| compile | `npx bsb -make-world` | Copies `lib/js` and `lib/bs` to `build/bucklescript/` |
| bundle | verify artifacts | Checks `build/bucklescript/js/**` or `lib/js/**` |
| test | `npm test` | Skipped when no `package.json` |

## Binaries

| Binary | Use case |
|--------|----------|
| `bsb` | Standard JavaScript output (default) |
| `bsb-native` | Native/in-source builds; auto-detected from `bsconfig.json` |

Override in `configure()`:

```lua
configure({
  { "coditary/bucklescript", {
      bsb_binary = "bsb",
      bsb_native_binary = "bsb-native",
      use_native = true,
  }},
})
```

## Detection

- Markers: `bsconfig.json`, `package.json`, `**/*.ml`, `**/*.re`
- Entry points: `src/*.re`, `src/*.ml`, or first matching source file
- Output: `build/bucklescript/js/` and `build/bucklescript/bs/`

## License

Apache License 2.0.
