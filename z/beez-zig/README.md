# zig

Official Zig compiler (**LLVM backend**) — `zig build` with auto-detected targets.

Plugin ID: **`coditary/zig`**

## Install

```lua
reqpack { beez = { { name = "coditary/zig", version = "1.0.0", source = "github:Coditary/beez-zig" } } }
```

## Usage

```lua
configure({ { "coditary/zig", {} } })
workflows({ build = "coditary/zig:build" })
```

```bash
beez build
beez -s coditary/zig:zig:compile
beez -p compile[zig]
```

## Steps

| Step | Command |
|------|---------|
| `zig:configure` | `zig build --fetch` (when `build.zig.zon` exists) |
| `zig:compile` | `zig build -Doptimize=ReleaseFast` |
| `zig:bundle` | Verify `zig-out/bin/**` |
| `zig:test` | `zig build test` |

## Profiles

| Profile | Optimize | Scope |
|---------|----------|-------|
| `code` | `ReleaseFast` | `zig` |
| `debug` | `Debug` | `zig` |

## Detection

Auto-detects via `ctx.glob`:

- `build.zig`, `build.zig.zon`
- `src/main.zig`, `src/*.zig`

Outputs: `zig-out/bin/**`, `.zig-cache/**`

## License

Apache License 2.0.
