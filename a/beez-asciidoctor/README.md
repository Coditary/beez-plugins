# asciidoctor

Official Asciidoctor document renderer — HTML via `asciidoctor`, PDF via `asciidoctor-pdf`.

Plugin ID: **`coditary/asciidoctor`**

## Install

```lua
reqpack { beez = { { name = "coditary/asciidoctor", version = "1.0.0", source = "github:Coditary/beez-asciidoctor" } } }
```

## Usage

```lua
configure({ { "coditary/asciidoctor", {} } })
```

```bash
beez -p compile[asciidoctor]
beez -s asciidoctor:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `asciidoctor` | `asciidoctor --version` | Verifies Asciidoctor binaries |
| compile | `asciidoctor` | `asciidoctor-pdf -o build/asciidoctor/out/app.pdf` | PDF via asciidoctor-pdf |
| bundle | `asciidoctor` | verify output | Checks build artifact |
| test | `test` | render tests or skip | Skipped when no test files detected |

Debug profile renders HTML with `asciidoctor -v`.

## Detection

- Markers: `**/*.adoc`
- Entry points: `index.adoc`, `README.adoc`, `main.adoc`, or first root `*.adoc`

## License

Apache License 2.0.
