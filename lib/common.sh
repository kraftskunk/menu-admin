#!/bin/bash
#
# ------------------------------------------------------------
#
# Common safety settings and helper functions for all scripts
#
# ------------------------------------------------------------


set -euo pipefail
IFS=$'\n\t'

# --- Trap cleanup on exit or error ---
cleanup() {
    :
}
trap cleanup EXIT

# --- Logging ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../script.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

# --- Usage helper ---
usage() {
    echo "Usage: $(basename "$0") [options]"
}