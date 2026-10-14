# netrexx

Official NetRexx compiler plugin — NetRexx nrc — compile .nrx sources to Java bytecode.

Plugin ID: **`coditary/netrexx`**

## Install

```lua
reqpack { beez = { { name = "coditary/netrexx", version = "1.0.0", source = "github:Coditary/beez-netrexx" } } }
```

## Usage

```lua
configure({ { "coditary/netrexx", {} } })
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[netrexx]
beez -s coditary/netrexx:compile:code
```

## Steps

| Phase | Scope | Notes |
|-------|-------|-------|
| setup | `netrexx` | Verify toolchain, create `build/netrexx/.netrexx-setup` |
| compile | `netrexx` | Compile sources to `build/netrexx/` |
| bundle | `netrexx` | Verify compile artifacts |
| test | `netrexx` | Writes `report/test/netrexx-*.ok` |

## Detection

- Markers: **/*.nrx
- Entry points: `main.nrx`, `src/main.nrx`, or first non-test `*.nrx`

## License

Apache License 2.0.
