# hipe

**HiPE native Erlang JIT/AOT compiler** — legacy OTP native compilation via `erlc +native` / `erl +native` with rebar3 or standalone erlc auto-detection.

Plugin ID: **`coditary/hipe`**

> **Legacy notice:** HiPE (High Performance Erlang) was removed in OTP 24. Modern Erlang/OTP uses a built-in JIT compiler instead. This plugin exists for maintaining legacy Erlang/OTP codebases (OTP 22 and earlier) that relied on HiPE native compilation. New projects should use current OTP with the default JIT.

## Install

```lua
reqpack { beez = { { name = "coditary/hipe", version = "1.0.0", source = "github:Coditary/beez-hipe" } } }
```

## Usage

```lua
configure({ { "coditary/hipe", {} } })
workflows({ build = "coditary/hipe:build" })
```

```bash
beez build
beez -p compile[hipe]
beez -s hipe:compile
```

## Detection

| Marker | Backend |
|--------|---------|
| `rebar.config` | rebar3 (`as native compile`, eunit/ct tests) |
| `**/*.erl` (no rebar) | Standalone `erlc +native` |

Artifacts are collected under `build/hipe/` (`ebin/`, `bin/`).

## Scope

Native builds use scope **`hipe`** (not `app`), matching the legacy HiPE compiler pipeline.

## Requirements

- OTP 22 or earlier with HiPE enabled (`erlc +native`, `erl +native`)
- `rebar3` on `PATH` for rebar-based projects

## License

Apache License 2.0.
