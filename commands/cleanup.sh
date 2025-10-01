#!/usr/bin/env bash
#DESC: Clean up /tmp
#TEST: args=; expect=Cleanup complete
source "$(dirname "$0")/../lib/common.sh"

log "Cleaning /tmp..."

# Try to clean, but don't exit on failure
if ! rm -rf /tmp/* 2>/dev/null; then
    log "⚠️ Some files in /tmp could not be removed"
fi

log "Cleanup complete."