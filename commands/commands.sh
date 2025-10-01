#!/usr/bin/env bash
#DESC: Show all available scripts
#TEST: args=; expect=Show commands
set -euo pipefail
IFS=$'\n\t'

source "$(dirname "$0")/../lib/common.sh"
COMMANDS_DIR="$(dirname "$0")"

# List all scripts in commands/
# --
echo ""
echo "Available commands:"
echo ""

mapfile -t scripts < <(find "$COMMANDS_DIR" -maxdepth 1 -type f -name "*.sh" -exec basename {} \; | sort)

for script in "${scripts[@]}"; do

	desc=$(grep -m1 '^#DESC:' "$COMMANDS_DIR/$script" | sed 's/^#DESC:[[:space:]]*//')
	printf "  %-15s %s\n" "${script%.sh}" "${desc:-}"
	echo ""

done

log "Show commands"