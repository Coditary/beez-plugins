# qiskit

Official OpenQASM/Qiskit transpiler with auto-detected `.qasm` circuits and `requirements.txt`.

Plugin ID: **`coditary/qiskit`**

## Install

```lua
reqpack { beez = { { name = "coditary/qiskit", version = "1.0.0", source = "github:Coditary/beez-qiskit" } } }
```

## Usage

```lua
configure({ { "coditary/qiskit", {} } })
```

```bash
beez -p compile[qiskit]
beez -s qiskit:compile
```

## Steps

| Phase | Scope | Command | Notes |
|-------|-------|---------|-------|
| setup | `qiskit` | `pip install -r requirements.txt` | Installs Qiskit dependencies |
| compile | `qiskit` | Qiskit transpile | Transpiles OpenQASM to optimized circuit |
| bundle | `qiskit` | verify output | Checks `build/qiskit/bin/app.qasm` |
| test | `qiskit` | `pytest` | Skipped when no test files are detected |

## Detection

- Markers: `**/*.qasm`, `requirements.txt`, `**/requirements.txt`
- Entry points: `main.qasm`, `circuit.qasm`, or first root `*.qasm`
- Tests: `tests/**/*.qasm`, `tests/**/*.py`, `*_test.qasm`

## License

Apache License 2.0.
