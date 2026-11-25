# Project Status

**Current phase:** Phase 0 — Research & Architecture
**Phase 0 gate (not yet met):** architecture, MVP scope, PDK/toolchain and targets approved by project owner.
**Last updated:** 2026-11-26

Status tags (CLAUDE.md §2.5): `PLANNED` · `IN PROGRESS` · `EXPERIMENTAL` · `IMPLEMENTED (unverified)` · `VERIFIED` (with evidence link).

## Verified results

None. No RTL exists. No simulation, lint, synthesis, timing or physical-design run has been performed.

## Phase 0 deliverables

| Deliverable | Status |
|---|---|
| Repository skeleton (CLAUDE.md §7 layout) | IMPLEMENTED (unverified) |
| Tool inventory (`reports/TOOL_VERSIONS.md`) | IMPLEMENTED (unverified) |
| `docs/REQUIREMENTS.md` (MVP scope, PROVISIONAL TARGETs) | PLANNED |
| `docs/ARCHITECTURE.md` (SoC block diagram, memory map, bus, interrupts, clock/reset) | PLANNED |
| ADRs: ISA/core, bus, PDK, flow, toolchain | PLANNED |
| `docs/VERIFICATION_PLAN.md` (strategy outline) | PLANNED |
| `docs/ASIC_IMPLEMENTATION_PLAN.md` (PDK + flow outline) | PLANNED |
| `docs/RISK_REGISTER.md` | PLANNED |
| `docs/BACKLOG.md` | PLANNED |

## Features

| Feature | Phase | Status |
|---|---|---|
| RV32I single-cycle core | 1 | PLANNED |
| RV32I 5-stage pipelined core (hazards, forwarding) | 1 | PLANNED |
| riscv-arch-test (RV32I) compliance | 1 | PLANNED |
| AXI4-Lite interconnect | 2 | PLANNED |
| On-chip SRAM | 2 | PLANNED |
| Timer | 2 | PLANNED |
| UART | 2 | PLANNED |
| Interrupt controller | 2 | PLANNED |
| DMA engine | 2 | PLANNED |
| SPI controller | 2 | PLANNED |
| I2C controller | 2 | PLANNED |
| Bare-metal software (crt0, linker script) | 2 | PLANNED |
| DSP accelerator (CSR, DMA-fed, done IRQ) | 3 | PLANNED |
| Structured DV (unit/integration/system, SVA, coverage, CI regression) | 4 | PLANNED |
| Formal verification (where useful) | 4 | PLANNED |
| ASIC synthesis + SDC | 5 | PLANNED |
| Physical design to GDS (DRC/LVS, signoff STA) | 6 | PLANNED |
| PPA optimization studies | 7 | PLANNED |
| Advanced features (AI accel, vector, multicore, caches) | 8 | PLANNED |
| FPGA prototype (secondary) | — | PLANNED |

## Done

- 2026-11-26: Repository skeleton created.
- 2026-11-26: Environment inventory (`reports/TOOL_VERSIONS.md`).
- 2026-11-26: OSS CAD Suite 2026-11-25 installed (yosys 0.71, sby, verilator 5.055, iverilog 14.0, cocotb 2.1.0.dev0); load with `source scripts/env.sh`. Tools run on the vendor fifo example: `reports/toolchain_smoke.log`.
- 2026-11-26: LibreLane 3.0.17 installed in `.venv` (`pnr/requirements.txt`).

## In progress

- LibreLane smoke test: run 1 FAILED (no TTY in the launching shell; flow never started). Needs a re-run from a terminal.

## Blocked

- Verible: not installed (awaiting owner decision).
- RISC-V GCC: not installed (decision 3 pending; needs sudo).
- spike / Sail: deferred to Phase 1.
- LibreLane smoke test / PD memory on this 7.1 GiB host: unmeasured (see `reports/TOOL_VERSIONS.md`).
- cocotb: installed but not exercised (first testbench comes in Phase 1).

## Next

- Re-run the LibreLane smoke test with a TTY; owner decisions 3–5 and Verible; then Phase 0 research and architecture documents.
