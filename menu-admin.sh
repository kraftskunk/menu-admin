#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

COMMANDS_DIR="$(dirname "$0")/commands"

while true; do
    clear
    echo "=== Dynamic Menu ==="
    echo "Available commands:"

    # Build list of available scripts
    mapfile -t scripts < <(find "$COMMANDS_DIR" -maxdepth 1 -type f -name "*.sh" -exec basename {} \; | sort)

    for i in "${!scripts[@]}"; do
        script_path="$COMMANDS_DIR/${scripts[$i]}"
        # Extract description from #DESC: line if present
        desc=$(grep -m1 '^#DESC:' "$script_path" | sed 's/^#DESC:[[:space:]]*//')
        printf "%2d) %-20s %s\n" "$((i+1))" "${scripts[$i]}" "${desc:-}"
    done
    printf "%2d) Quit\n" "$(( ${#scripts[@]} + 1 ))"

    read -rp "Select an option: " choice

    if [[ "$choice" -eq $(( ${#scripts[@]} + 1 )) ]]; then
        echo "Goodbye!"
        exit 0
    fi

    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#scripts[@]} )); then
        script="${scripts[$((choice-1))]}"
        bash "$COMMANDS_DIR/$script"
        read -rp "Press Enter to return to menu..."
    else
        echo "Invalid choice."
        sleep 1
    fi
done