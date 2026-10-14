# elua

Official eLua compiler plugin — embedded Lua for microcontrollers via **scons** and **arm-none-eabi-gcc**.

Plugin ID: **`coditary/elua`**

eLua targets bare-metal and RTOS platforms (STM32, LPC, AVR, and similar MCUs). This plugin wraps the standard eLua SCons build, copies firmware artifacts into `build/elua/`, and validates application Lua scripts on the host.

## Install

```lua
reqpack { beez = { { name = "coditary/elua", version = "1.0.0", source = "github:Coditary/beez-elua" } } }
```

## Usage

```lua
configure({
    { "coditary/elua", {
        platform = "stm32f4discovery",  -- MCU target from platform_data.lua
        default_platform = "linux",     -- host fallback for tests
    }},
})
workflows({ build = "coditary/pipeline:build" })
```

```bash
beez -p compile[elua]
beez -s coditary/elua:compile:code
beez -s elua:compile
```

Set the cross-compilation target via `configure().platform` or the `ELUA_TARGET` environment variable.

## Steps

| Phase | Command | Notes |
|-------|---------|-------|
| setup | verify `scons`, `arm-none-eabi-gcc`, `lua` | Creates `build/elua/.elua-setup` |
| compile | `scons target=<platform>` | Copies firmware to `build/elua/` |
| bundle | verify firmware | Checks `.elf`, `.bin`, or `elua` binary |
| test | host Lua load / linux build | Validates `src/**/*.lua` scripts |

## Detection

- Markers: `SConstruct`, `platform_data.lua`, `src/**/*.lua`
- Platform: `configure().platform`, `ELUA_TARGET`, or `default_platform` (fallback: `linux`)
- Output: `build/elua/` (copied from eLua's `0.9/<platform>/` build tree)

## Embedded / Microcontroller Focus

- Requires **ARM GCC cross toolchain** (`arm-none-eabi-gcc`) for MCU firmware builds
- Platform definitions live in `platform_data.lua` (board clocks, memory map, peripherals)
- Application logic in `src/**/*.lua` is validated on the host before flashing
- Use `platform = "linux"` for host-side eLua builds during development

## License

Apache License 2.0.
