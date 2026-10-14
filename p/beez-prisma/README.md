# prisma

Official Prisma ORM plugin — generate Prisma Client from `schema.prisma` with auto-detection.

Plugin ID: **`coditary/prisma`**

## Install

```lua
reqpack { beez = { { name = "coditary/prisma", version = "1.0.0", source = "github:Coditary/beez-prisma" } } }
```

## Usage

```lua
configure({ { "coditary/prisma", {} } })
```

```bash
beez -p compile[prisma]
beez -s prisma:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `prisma` | `npx prisma --version` | Verifies Prisma CLI and schema |
| compile | `prisma` | `npx prisma generate` | Generates Prisma Client |
| bundle | `prisma` | verify client | Checks generated client artifacts |
| test | `prisma` | `npx prisma validate` | Validates schema syntax |

## Detection

- Markers: `schema.prisma`, `**/schema.prisma`
- Entry point: shallowest `schema.prisma`, or `schema_path` in configure()

## License

Apache License 2.0.
