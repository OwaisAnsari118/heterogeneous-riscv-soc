# Tool Versions & Environment Inventory

**Captured:** 2026-11-26 (Phase 0, before any installs)
**Raw evidence:** [`env_check.log`](env_check.log), [`env_check_extra.log`](env_check_extra.log)
**Regenerate:** `scripts/check_env.sh > reports/env_check.log 2>&1`

Every value below is copied from those logs. `BLOCKED` = not found on this machine; no flow
step that depends on it may be claimed as run.

## Host

| Item | Value | Command used |
|---|---|---|
| OS | Ubuntu 24.04.4 LTS (Noble Numbat) | `cat /etc/os-release` |
| Kernel / arch | Linux 7.0.0-43-generic x86_64 | `uname -srm` |
| CPU | AMD Ryzen 5 5500U, 6 cores / 12 threads, 1 socket | `lscpu` |
| Logical CPUs | 12 | `nproc` |
| RAM | 7.1 GiB total, 1.9 GiB available at capture; swap 4.0 GiB | `free -h` |
| Free disk | 58 GB free of 282 GB (79% used); repo, /home, /tmp share one partition | `df -h` |
| Python packaging | System Python is PEP 668 "externally managed" → use a venv; `venv` + `ensurepip` 24.0 present | `ls /usr/lib/python3*/EXTERNALLY-MANAGED`, `python3 -m venv --help` |
| Docker access | User in `docker` group; daemon reachable without sudo (server 29.1.3, sees 7.6 GB RAM, 12 CPUs) | `id -nG`, `docker info` |

## Tools

| Tool | Found? | Version | Command used |
|---|---|---|---|
| verilator | Yes (`/usr/bin/verilator`, apt) | Verilator 5.020 2024-01-01 rev (Debian 5.020-1) | `verilator --version` |
| iverilog | Yes (`/usr/bin/iverilog`, apt) | Icarus Verilog version 12.0 (stable) | `iverilog -V` |
| verible | **BLOCKED** | — | `which verible-verilog-lint`, `which verible-verilog-format` |
| yosys | **BLOCKED** | — | `which yosys` |
| sby (SymbiYosys) | **BLOCKED** | — | `which sby` |
| openroad | **BLOCKED** | — | `which openroad` |
| sta (OpenSTA) | **BLOCKED** | — | `which sta` |
| magic | **BLOCKED** | — | `which magic` |
| klayout | **BLOCKED** | — | `which klayout` |
| netgen | **BLOCKED** | — | `which netgen` |
| python3 | Yes (`/usr/bin/python3`) | Python 3.12.3 | `python3 --version` |
| pip | Yes (`/usr/bin/pip3`) | pip 24.0 (python 3.12) | `pip3 --version` |
| cocotb | **BLOCKED** | — (`WARNING: Package(s) not found: cocotb`) | `python3 -m pip show cocotb` |
| RISC-V GCC | **BLOCKED** | — (no `riscv32-*gcc` / `riscv64-*gcc` on PATH) | `compgen -c \| grep -E '^riscv(32\|64)-.*gcc$'` |
| spike | **BLOCKED** | — | `which spike` |
| docker | Yes (`/usr/bin/docker`) | Docker version 29.1.3, build 29.1.3-0ubuntu3~24.04.2 | `docker --version` |
| nix | **BLOCKED** | — | `which nix` |
| make | Yes (`/usr/bin/make`) | GNU Make 4.3 | `make --version` |
| git | Yes (`/usr/bin/git`) | git version 2.43.0 | `git --version` |
| gtkwave (extra) | Yes (`/usr/bin/gtkwave`, apt) | GTKWave Analyzer v3.3.116 | `gtkwave --version` |

Also probed, not found: `pipx`, `conda`, `surfer`. No PDK (`sky130A`, `gf180*`, `.volare`, `.ciel`)
or OSS CAD Suite was found under `/opt` or `~` (depth 4). Available package managers: apt 2.8.4, snap 2.77.1.

## Notes

- `iverilog -V` exit code 141 in the log is SIGPIPE from `| head`, not a tool failure.
- **Resource risk:** 7.1 GiB RAM, with only ~1.9 GiB free at capture, is tight for
  OpenROAD global/detailed routing and KLayout/Magic DRC on a full SoC. 58 GB of free disk
  is enough for one PDK plus runs, but not for several PDK versions plus many run directories.
  To be recorded in `docs/RISK_REGISTER.md`.
- Verilator 5.020 (Ubuntu apt) is from January 2024. Whether it is new enough for the chosen
  cocotb version and SV features is unchecked; this goes into the toolchain ADR.
