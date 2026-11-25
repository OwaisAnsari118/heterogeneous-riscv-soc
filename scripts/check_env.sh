#!/usr/bin/env bash
# Environment inventory probe. Prints raw output of `which` and each tool's
# version command. Installs nothing. Output is the evidence behind
# reports/TOOL_VERSIONS.md; regenerate with:
#   scripts/check_env.sh > reports/env_check.log 2>&1
set -u

run() {  # run <label> <command...>
  echo "=== $1"
  echo "\$ ${*:2}"
  "${@:2}" 2>&1 | head -n 5
  echo "[exit=${PIPESTATUS[0]}]"
  echo
}

echo "# check_env.sh run at $(date -Is)"
echo

echo "##### SYSTEM"
run os        cat /etc/os-release
run kernel    uname -srm
run cores     nproc
run cpu       bash -c "lscpu | grep -E 'Model name|^CPU\(s\)|Thread|Core|Socket'"
run ram       free -h
run disk      df -h "$(pwd)" /home /tmp

echo "##### TOOLS"
probe() {  # probe <binary> <version args...>
  echo "=== $1"
  echo "\$ which $1"
  if p=$(command -v "$1"); then
    echo "$p"
    echo "\$ $1 ${*:2}"
    timeout 20 "$1" "${@:2}" 2>&1 | head -n 5
    echo "[exit=${PIPESTATUS[0]}]"
  else
    echo "NOT FOUND"
  fi
  echo
}

probe verilator --version
probe iverilog  -V
probe verible-verilog-lint --version
probe verible-verilog-format --version
probe yosys     -V
probe sby       --help
probe openroad  -version
probe sta       -version
probe magic     --version
probe klayout   -v
probe netgen    -batch quit
probe python3   --version
probe pip3      --version

echo "=== cocotb"
echo "\$ python3 -m pip show cocotb"
python3 -m pip show cocotb 2>&1 | head -n 5; echo "[exit=${PIPESTATUS[0]}]"
echo "\$ which cocotb-config"
command -v cocotb-config || echo "NOT FOUND"
echo

echo "=== riscv gcc (any prefix)"
echo "\$ compgen -c | grep -E '^riscv(32|64)-.*gcc\$'"
found=$(compgen -c | grep -E '^riscv(32|64)-.*gcc$' | sort -u)
if [ -n "$found" ]; then
  for g in $found; do echo "$(command -v "$g")"; "$g" --version 2>&1 | head -n 1; done
else
  echo "NOT FOUND"
fi
echo

probe spike     --help
probe docker    --version
probe nix       --version
probe make      --version
probe git       --version

echo "##### PACKAGE MANAGERS"
probe apt       --version
probe snap      --version
probe pipx      --version
probe conda     --version
