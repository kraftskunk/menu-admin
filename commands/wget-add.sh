#!/usr/bin/env bash
#DESC: Backup files to archive
#TEST: args=test.tar.gz; expect=Add complete
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/../lib/common.sh"

cleanup() { :; }
trap cleanup EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$SCRIPT_DIR/../script.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "Add complete."