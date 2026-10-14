# reason

Official ReasonML / ReScript compiler plugin — refmt, bsc, and rescript build with auto-detected `.re`/`.rei` targets.

Plugin ID: **`coditary/reason`**

## Install

```lua
reqpack { beez = { { name = "coditary/reason", version = "1.0.0", source = "github:Coditary/beez-reason" } } }
```

## Usage

```lua
configure({ { "coditary/reason", {} } })
```

```bash
beez -p compile[reason]
beez -s reason:compile
```

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | `refmt --version` / `npm install` | From `rescript.json` or `bsconfig.json` |
| compile | `rescript build` / `bsc -make-world` | Writes compile stamp under `build/reason/` |
| bundle | verify compile stamp | Checks `build/reason/.reason-compile-*` |
| test | `rescript test` / `npm test` | Writes `report/test/reason-*.ok` |

## Detection

- Markers: `rescript.json`, `bsconfig.json`, `**/*.re`, `**/*.rei`
- Compile targets: all non-test `.re` and `.rei` files
- Binaries: `bsc`, `refmt`, `rescript` (override with `BSC`, `REFMT`, `RESCRIPT` env)

## License

Apache License 2.0.
