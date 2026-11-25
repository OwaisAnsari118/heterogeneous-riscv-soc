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

## Update 2026-11-26: front-end toolchain installed (owner decision 1A)

**Route:** OSS CAD Suite, one pinned dated release, user-space (no sudo, no `.bashrc` change).
- Archive: `oss-cad-suite-linux-x64-20261125.tgz` from
  https://github.com/YosysHQ/oss-cad-suite-build/releases/tag/2026-11-25
- sha256 `71c5f52ce8e5c44cbc0d5a5bb1aed654f36f3a999d4e13f4c68e076946451bbe`, verified with `sha256sum -c` (OK)
- Installed to `~/tools/oss-cad-suite-20261125` (2.5 GB)
- Load per shell: `source scripts/env.sh`
- **Raw evidence:** [`toolchain_check.log`](toolchain_check.log)

| Tool | Found? | Version | Command used (after `source scripts/env.sh`) |
|---|---|---|---|
| yosys | Yes | Yosys 0.71+115 (git sha1 ab83f23a2, Release, Clang /usr/bin/clang++ 21.1.8) | `yosys -V` |
| sby | Yes | no version flag; `sby --help` runs | `sby --help` |
| eqy | Yes | no version flag; `eqy --help` runs | `eqy --help` |
| verilator | Yes | Verilator 5.055 devel rev v5.054-396-ge7d094587 (mod) | `verilator --version` |
| iverilog | Yes | Icarus Verilog version 14.0 (devel) (s20260301-1291-g3f05f92b0-dirty) | `iverilog -V` |
| python3 (suite) | Yes | Python 3.11.6 | `python3 --version` |
| cocotb | Yes | 2.1.0.dev0+41564633 | `cocotb-config --version` |
| verible | **BLOCKED** (not part of decision 1A) | — | `which verible-verilog-lint` |

With `scripts/env.sh` sourced, these binaries shadow the apt Verilator 5.020 and Icarus 12.0 in
`/usr/bin`. Without it, the apt versions are used.

**Smoke test on the vendor example** (`$OSS_CAD_SUITE/examples/fifo`, not project RTL; it
shows only that the tools run): [`toolchain_smoke.log`](toolchain_smoke.log)
- `yosys ... synth -top fifo` → exit 0, generic-cell netlist produced
- `verilator --lint-only -Wall fifo.sv` → exit 1 with 2 warnings (DECLFILENAME, WIDTHEXPAND)
  in the vendor code, so lint runs and reports
- `sby -f fifo.sby basic` → `DONE (PASS, rc=0)`
- cocotb: **found, not exercised**. The suite ships no cocotb example, and writing a testbench waits for Phase 1.

**Caveat (reproducibility):** the nightly suite bundles *development snapshots* (Verilator
5.055 devel, cocotb 2.1.0.dev0, Icarus 14.0 devel), not tagged releases. They are pinned by
the archive's sha256, so results can be reproduced, but not by upstream release tags.
To be recorded in the risk register.

## Update 2026-11-26: LibreLane installed (owner decision 2A)

- `librelane==3.0.17` (latest stable on PyPI at install time) in the gitignored project venv
  `.venv` (system Python 3.12.3), pinned in [`pnr/requirements.txt`](../pnr/requirements.txt)
- Run mode: `--dockerized` (Docker 29.1.3)
- Image pulled: `ghcr.io/librelane/librelane:3.0.17`,
  digest `sha256:24640bd645ae992fa22d4a3e18fde10d728763c78fb140184f9975aa6c7d3e5e`

| Smoke test | Command | Result | Evidence |
|---|---|---|---|
| Run 1 (2026-11-26 00:30) | `.venv/bin/python -m librelane --dockerized --smoke-test` | **FAIL**, an environment problem, not a design or RAM failure: after the image pull, `the input device is not a TTY`, exit 1. The wrapper asks Docker for an interactive terminal, and the run was launched from a non-interactive background shell. The flow never started, and no PDK was downloaded. | [`pnr/librelane_smoke_run1_notty.log`](pnr/librelane_smoke_run1_notty.log) |

The memory samples from run 1 ([`pnr/librelane_smoke_run1_mem.log`](pnr/librelane_smoke_run1_mem.log))
only show idle host usage (host used ≤ 4507 MiB, available ≥ 2756 MiB) because no flow container
ran. They are **not** evidence of LibreLane's memory needs. Peak PD memory on this host is still
**unmeasured**.

**LibreLane status: installed, smoke test BLOCKED** until it is re-run from a terminal (TTY).

## Notes

- `iverilog -V` exit code 141 in the log is SIGPIPE from `| head`, not a tool failure.
- **Resource risk:** 7.1 GiB RAM, with only ~1.9 GiB free at capture, is tight for
  OpenROAD global/detailed routing and KLayout/Magic DRC on a full SoC. 58 GB of free disk
  is enough for one PDK plus runs, but not for several PDK versions plus many run directories.
  To be recorded in `docs/RISK_REGISTER.md`.
- Verilator 5.020 (Ubuntu apt) is from January 2024. Whether it is new enough for the chosen
  cocotb version and SV features is unchecked; this goes into the toolchain ADR.
