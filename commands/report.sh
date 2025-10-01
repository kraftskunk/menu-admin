#!/usr/bin/env bash
#DESC: Generate a system overview report
#TEST: args=; expect=Report complete
source "$(dirname "$0")/../lib/common.sh"

log "Generating report..."
clear
echo ""
uname -a
echo ""
echo ""
df -h
echo ""
echo ""
log "Report complete."
