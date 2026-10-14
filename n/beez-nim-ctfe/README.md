# nim-ctfe

Nim compile-time execution (CTFE) and macro evaluation via the integrated **NimVM**.

Plugin ID: **`coditary/nim-ctfe`**

## About NimVM and CTFE

Nim ships with **NimVM** built into the `nim` compiler. NimVM interprets Nim code at compile time, powering:

- **CTFE** — `static:` blocks and `const` expressions evaluated during compilation
- **Macros** — `macro` and `template` definitions expanded before code generation
- **Static introspection** — `when`, `static:` loops, and compile-time type computation

No separate runtime or VM binary is required — CTFE runs inside `nim` itself.

## Install

```lua
reqpack { beez = { { name = "coditary/nim-ctfe", version = "1.0.0", source = "github:Coditary/beez-nim-ctfe" } } }
```

## Usage

```lua
configure({ { "coditary/nim-ctfe", {} } })
```

```bash
beez -p setup[ctfe]
beez -p compile[ctfe]
beez -p bundle[ctfe]
beez -p test[ctfe]
```

Or run individual steps:

```bash
beez -s coditary/nim-ctfe:compile:code
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `ctfe` | `nim --version` / `nimble install -d` | Creates `build/nim-ctfe/` |
| compile | `ctfe` | `nim --eval` + `nim r` | CTFE sanity eval, then compile-and-run targets |
| bundle | `ctfe` | verify artifacts | Checks `build/nim-ctfe/out/**` |
| test | `ctfe` | `nim test` / `nim r tests/test_ctfe.nim` | Uses nimble when `.nimble` present |

## Compile commands

The compile step runs two kinds of CTFE evaluation:

1. **`nim --eval:'static: echo "nim-ctfe ok"'`** — inline NimVM evaluation (configurable via `eval_snippet`)
2. **`nim r --out:build/nim-ctfe/out/<name> <source>`** — compile-and-run (`nim compile --run`) for detected entry points

## Detection

- Markers: `**/*.nim`
- Entry points (first match): `ctfe/main.nim`, `ctfe/eval.nim`, `src/ctfe.nim`, `ctfe.nim`, `src/main.nim`, `main.nim`
- Output directory: `build/nim-ctfe/out/`

## Configuration

```lua
configure({
  { "coditary/nim-ctfe", {
    eval_snippet = 'static: echo "custom ctfe check"',
    targets = {
      { source = "ctfe/demo.nim", name = "demo", mode = "run" },
      { eval = 'static: echo 42', name = "inline", mode = "eval", output = "build/nim-ctfe/out/inline" },
    },
  }},
})
```

## License

Apache License 2.0.
