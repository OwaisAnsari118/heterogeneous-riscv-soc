# Heterogeneous RISC-V SoC (ASIC-first)

A from-scratch heterogeneous RISC-V system-on-chip, designed ASIC-first. The plan is a
pipelined RV32I core on an AXI4-Lite SoC fabric with on-chip SRAM, standard peripherals
(timer, UART, interrupts, DMA, SPI, I2C) and a CSR-controlled DSP accelerator. Each block
is meant to go through specification, RTL, structured verification and open-source ASIC
synthesis, and the design is meant to end in a physically implemented layout (GDS) with
documented timing and PPA. FPGA prototyping is secondary.

**Status: Phase 0 — architecture in progress.**

Nothing has been implemented yet. There is no RTL, and nothing has been simulated,
verified, synthesized or laid out. Per-feature status is tracked in
[docs/PROJECT_STATUS.md](docs/PROJECT_STATUS.md), and tool availability in
[reports/TOOL_VERSIONS.md](reports/TOOL_VERSIONS.md).
