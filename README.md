# beez-plugins

All Beez workflow plugin sources in one tree.

## Layout

Plugins live under a single letter directory derived from the name **after** the `beez-` prefix:

```
beez-plugins/
  a/beez-abap/
  a/beez-agda/
  c/beez-clang/
  c/beez-conan/
  g/beez-go/
  …
```

Example: `beez-clang` → `c/beez-clang` (first letter of `clang`).

Each plugin directory is a self-contained Beez package (`beez_plugin.lua`, `beez.package.json`, …).
