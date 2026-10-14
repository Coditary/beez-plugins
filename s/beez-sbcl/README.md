# sbcl

Steel Bank Common Lisp (**SBCL**) — AOT native compiler with ASD system and build-script auto-detection.

Plugin ID: **`coditary/sbcl`**

## Install

```lua
reqpack { beez = { { name = "coditary/sbcl", version = "1.0.0", source = "github:Coditary/beez-sbcl" } } }
```

## Usage

```lua
configure({ { "coditary/sbcl", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez build
beez -p compile[sbcl]
beez -s sbcl:compile
```

## Auto-detection

| Marker | Role | Setup | Compile |
|--------|------|-------|---------|
| `*.asd` | ASDF system definition | SBCL version check | `sbcl --load build.lisp` |
| `**/*.lisp`, `**/*.cl` | Source files | prepare `build/sbcl/` | load build script |
| `build.lisp` / `build.cl` / `build` | Build script | — | `sbcl --non-interactive --load <script> --quit` |

## Output

- Binaries: `build/sbcl/bin/`

## License

Apache License 2.0.
