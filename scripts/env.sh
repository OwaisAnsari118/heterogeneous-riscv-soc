# Project tool environment. SOURCE this, do not execute it:
#   source scripts/env.sh
# Loads the pinned OSS CAD Suite release (yosys, sby, verilator, iverilog,
# cocotb, its own python3) into the current shell only. Nothing is written to
# ~/.bashrc. Override the location with OSS_CAD_SUITE=/path before sourcing.
#
# Pinned release: oss-cad-suite-linux-x64-20261125.tgz
#   sha256 71c5f52ce8e5c44cbc0d5a5bb1aed654f36f3a999d4e13f4c68e076946451bbe
#   https://github.com/YosysHQ/oss-cad-suite-build/releases/tag/2026-11-25

if [ "${BASH_SOURCE-}" = "$0" ]; then
  echo "source this script: source $0" >&2
  exit 1
fi

OSS_CAD_SUITE="${OSS_CAD_SUITE:-$HOME/tools/oss-cad-suite-20261125}"
if [ ! -f "$OSS_CAD_SUITE/environment" ]; then
  echo "BLOCKED: OSS CAD Suite not found at $OSS_CAD_SUITE" >&2
  return 1
fi
# shellcheck disable=SC1091
source "$OSS_CAD_SUITE/environment"
export OSS_CAD_SUITE

# Verible (lint/format), pinned static release:
#   verible-v0.0-4302-gc6b29d62-linux-static-x86_64.tar.gz
#   sha256 f097fcad8e8ada021a9e14ef43be749a5b66095b9a2ab449f775f2337d8462b5
#   https://github.com/chipsalliance/verible/releases/tag/v0.0-4302-gc6b29d62
VERIBLE_HOME="${VERIBLE_HOME:-$HOME/tools/verible-v0.0-4302-gc6b29d62}"
if [ -x "$VERIBLE_HOME/bin/verible-verilog-lint" ]; then
  PATH="$VERIBLE_HOME/bin:$PATH"
  export PATH VERIBLE_HOME
else
  echo "BLOCKED: Verible not found at $VERIBLE_HOME" >&2
fi
